#!/bin/sh

progname=${0##*/}

usage()
{
	cat 1>&2 << _USAGE_
Usage: $progname [-s service] [-m megabytes] [-i image] [-x set]
       [-k kernel] [-o] [-c URL]
	Create a root image
	-s service	service name, default "rescue"
	-r rootdir	hand crafted root directory to use
	-m megabytes	image size in megabytes, default 10
	-i image	image name, default rescue-[arch].img
	-x sets		list of NetBSD sets, default rescue.tgz
	-k kernel	kernel to copy in the image
	-c URL		URL to a script to execute as finalizer
	-o		read-only root filesystem
_USAGE_
	exit 1
}

rsynclite()
{
	[ ! -d $1 -o ! -d $2 ] && return
	(cd $1 && tar cfp - .)|(cd $2 && tar xfp -)
}

options="s:m:i:r:x:k:c:oh"

while getopts "$options" opt
do
	case $opt in
	s) svc="$OPTARG";;
	m) megs="$OPTARG";;
	i) img="$OPTARG";;
	r) rootdir="$OPTARG";;
	x) sets="$OPTARG";;
	k) kernel="$OPTARG";;
	c) curlsh="$OPTARG";;
	o) rofs=y;;
	h) usage;;
	*) usage;;
	esac
done

export ARCH PKGVERS

arch=${ARCH:-"amd64"}

svc=${svc:-"rescue"}
megs=${megs:-"20"}
img=${img:-"rescue-${arch}.img"}
sets=${sets:-"rescue.tar.xz"}

OS=$(uname -s)
TAR=tar
FETCH=curl

case $OS in
NetBSD)
	is_netbsd=1
	FETCH=ftp
	;;
Linux)
	is_linux=1
	# avoid sets and pkgs untar warnings
	TAR=bsdtar
	;;
Darwin)
	# might be supported in the future
	is_darwin=1;;
OpenBSD)
	is_openbsd=1;;
*)
	is_unknown=1;
esac

for tool in $TAR # add more if needed
do
	if ! command -v $tool >/dev/null; then
		echo "$tool missing"
		exit 1
	fi
done

export TAR FETCH

if [ -z "$is_netbsd" -a -f "service/${svc}/NETBSD_ONLY" ]; then
	printf "\nThis image must be built on NetBSD!\n"
	printf "Use: make SERVICE=<service> build\n"
	exit 1
fi

[ -n "$is_darwin" -o -n "$is_unknown" ] && \
	echo "${progname}: OS is not supported" && exit 1

if [ -n "$is_linux" ]; then
	u=M
else
	u=m
fi

dd if=/dev/zero of=./${img} bs=1 count=0 seek=${megs}${u}

mkdir -p mnt
mnt=$(pwd)/mnt

if [ -n "$is_linux" ]; then
	mke2fs -O none $img
	mount -o loop $img $mnt
	mountfs="ext2fs"
else # NetBSD (and probably OpenBSD)
	vnd=$(vndconfig -l|grep -m1 'not'|cut -f1 -d:)
	vndconfig $vnd $img
	newfs -o time -O2 /dev/${vnd}a
	mount -o log,noatime /dev/${vnd}a $mnt
	mountfs="ffs"
fi

# $rootdir can be relative, don't cd mnt yet
for d in sbin bin dev etc/include
do
	mkdir -p ${mnt}/$d
done
# root fs built by sailor or hand made
if [ -n "$rootdir" ]; then
	$TAR cfp - -C "$rootdir" . | $TAR xfp - -C $mnt
# use a set and customization in services/
else
	for s in ${sets} ${ADDSETS}
	do
		# don't prepend sets path if this is a full path
		case $s in */*) ;; *) s="sets/${arch}/${s}" ;; esac
		echo -n "extracting ${s}.. "
		$TAR xfp ${s} -C ${mnt}/ || exit 1
		echo done
	done

fi
# additional packages
[ -n "$ADDPKGS" ] && for pkg in ${ADDPKGS}; do
		eval $($TAR xfp $pkg -O +BUILD_INFO|grep ^LOCALBASE)
		echo -n "extracting $pkg to ${LOCALBASE}.. "
		mkdir -p ${mnt}/${LOCALBASE}
		$TAR xfp ${pkg} -C ${mnt}/${LOCALBASE} || exit 1
		echo done
	done

[ -n "$rofs" ] && mountopt="ro" || mountopt="rw"
[ "$mountfs" = "ffs" ] && mountopt="${mountopt},log,noatime"
echo "ROOT.a / $mountfs $mountopt 1 1" > ${mnt}/etc/fstab

rsynclite service/${svc}/etc/ ${mnt}/etc/
rsynclite service/common/ ${mnt}/etc/include/
[ -d service/${svc}/packages ]  && \
	rsynclite service/${svc}/packages ${mnt}/

[ -n "$kernel" ] && cp -f $kernel ${mnt}/

cd $mnt

if [ "$svc" = "rescue" ]; then
	for b in init mount_ext2fs
	do
		ln -s /rescue/$b sbin/
	done
	ln -s /rescue/sh bin/
fi

# warning, postinst operations are done on the builder

[ -d ../service/${svc}/postinst ] && \
	for x in ../service/${svc}/postinst/*.sh
	do
		# if SVCIMG variable exists, only process its script
		if [ -n "$SVCIMG" ]; then
			[ "${x##*/}" != "${SVCIMG}.sh" ] && continue
			echo "SVCIMG=$SVCIMG" > etc/svc
		fi
		echo "executing $x"
		[ -f $x ] && sh $x
	done

# newer NetBSD versions use tmpfs for /dev, sailor copies MAKEDEV from /dev
# backup MAKEDEV so imgbuilder rc can copy it
cp dev/MAKEDEV etc/
# unionfs with ext2 leads to i/o error
sed -i 's/-o union//g' dev/MAKEDEV
# record wanted pkgsrc version
echo "PKGVERS=$PKGVERS" > etc/pkgvers

# proceed with caution
[ -n "$curlsh" ] && curl -sSL "$CURLSH" | /bin/sh

cd ..

umount $mnt

[ -z "$is_linux" ] && vndconfig -u $vnd

exit 0

# Week 7: Data Security, Encryption, and Replication in AWS S3

## Overview
This week focused on enhancing data security and resilience by:
- Creating and managing KMS encryption keys
- Applying encryption policies on S3 buckets
- Enabling versioning for backup and restore capabilities
- Implementing replication rules for disaster recovery

---

## 1. **KMS Key Creation and Management**
- A symmetric customer-managed key was created in **AWS KMS** for encrypting and decrypting S3 objects.
- Screenshot reference: `image1.png`

> ✅ **Hint:** Place this screenshot in a folder `kms-key/` with a filename like `kms-key-created.png`.

---

## 2. **Applying Default Bucket Encryption Using KMS**
- The S3 bucket `academics-raw-lok` was configured to use server-side encryption (SSE-KMS).
- The specific KMS key (Key ID: `58502f32...`) was applied as the default encryption key.
- Screenshot reference: `image2.png`

> ✅ **Hint:** Save this screenshot in a subfolder `s3-bucket-security/` as `default-encryption-kms.png`.

---

## 3. **Enabling Bucket Versioning**
- Versioning was enabled on the same S3 bucket `academics-raw-lok`.
- This protects against accidental overwrites and deletions.
- Screenshot reference: `image3.png`

> ✅ **Hint:** Save this image in `s3-bucket-security/` as `versioning-enabled.png`

---

## 4. **Replication Rules Configuration**
- Three replication rules were created to replicate data from `academics-raw-lok` to `academics-raw-bac-lok` bucket.
  - aca-pre-rep-rul-lok
  - aca-fac-rep-rul-lok
  - aca-panel-rep-rul-lok
- These are applied to the entire bucket scope, and include encrypted objects.
- Screenshot reference: `image4.png`

> ✅ **Hint:** Save this image in a subfolder `replication-rules/` as `all-rules-configured.png`

---

## Directory Structure Suggestion
```plaintext
week-07/
├── kms-key/
│   └── kms-key-created.png
├── s3-bucket-security/
│   ├── default-encryption-kms.png
│   └── versioning-enabled.png
├── replication-rules/
│   └── all-rules-configured.png
└── README.md
```

---![image1](https://github.com/user-attachments/assets/c8fa68df-5a28-46f0-9e13-0f026236bf58)
![image4](https://github.com/user-attachments/assets/0d593510-d6fe-44ca-b35e-0e24c35fde8a)
![image3](https://github.com/user-attachments/assets/1c22d90c-ab90-4977-af30-011744a91994)
![image2](https://github.com/user-attachments/assets/fea36bd7-21d0-41e6-85f0-53af0679540d)


## Summary
This week implemented best practices around:
- Data confidentiality (KMS-based encryption)
- Data durability and safety (versioning)
- Business continuity (cross-region replication)

> These configurations help ensure your cloud architecture is **secure, compliant, and resilient**.

---

Let me know if you’d like me to generate `README.md` files for previous weeks in the same structured Git format!

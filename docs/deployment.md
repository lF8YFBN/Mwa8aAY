# Deployment Guide

This guide provides detailed instructions for deploying the Financial Dashboard application to AWS.

## Prerequisites

Before deploying the application, ensure you have the following prerequisites installed and configured:

- **AWS CLI**: Installed and configured with appropriate credentials
- **Terraform**: Version 1.0.0 or later
- **Node.js and npm**: Version 14.x or later
- **Git**: For version control

You can verify your installations with:

```bash
# Check AWS CLI installation
aws --version

# Check Terraform installation
terraform --version

# Check Node.js and npm installation
node --version
npm --version

# Check Git installation
git --version
```

## Deployment Options

The Financial Dashboard application can be deployed in two ways:

1. **Automated Deployment**: Using the provided deployment script
2. **Manual Deployment**: Step-by-step deployment process

Both methods require you to clone the repository first:

```bash
# Navigate to your desired directory
cd ~/projects

# Clone the repository
git clone https://github.com/your-username/financial-dashboard.git

# Navigate to the project directory
cd financial-dashboard
```

## Option 1: Automated Deployment

For a quick and seamless deployment, use the provided deployment script:

```bash
# Make the deployment script executable
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

The script will:
- Check for required tools and AWS credentials
- Deploy the infrastructure using Terraform
- Configure and build the frontend application
- Deploy the frontend to S3
- Display the deployment information and URLs

## Option 2: Manual Deployment

If you prefer to deploy the application step by step, follow these instructions:

### 1. Deploy Infrastructure with Terraform

```bash
# Navigate to the Terraform directory
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Apply the Terraform configuration
terraform apply

# After confirming, note the outputs for later use
terraform output
```

Important outputs to note:
- `api_gateway_url`: The URL for the API Gateway endpoint
- `cognito_user_pool_id`: The ID of the Cognito User Pool
- `cognito_client_id`: The ID of the Cognito User Pool Client
- `cloudfront_distribution_url`: The URL of the CloudFront distribution
- `frontend_bucket_name`: The name of the S3 bucket for the frontend

### 2. Configure the Frontend

```bash
# Navigate to the frontend directory
cd ../../src/frontend

# Create a new .env file from the example
cp .env.example .env
```

Edit the `.env` file with the values from your Terraform outputs:

```
REACT_APP_AWS_REGION=your-aws-region
REACT_APP_USER_POOL_ID=your-user-pool-id
REACT_APP_USER_POOL_CLIENT_ID=your-user-pool-client-id
REACT_APP_API_URL=your-api-gateway-url
REACT_APP_ENV=development
```

### 3. Build and Deploy the Frontend

```bash
# Install dependencies
npm install

# Build the application
npm run build

# Deploy to S3 bucket
aws s3 sync build/ s3://$(terraform -chdir=../../terraform/environments/dev output -raw frontend_bucket_name)/ --delete
```

### 4. Verify the Deployment

```bash
# Get the CloudFront URL
CLOUDFRONT_URL=$(terraform -chdir=../../terraform/environments/dev output -raw cloudfront_distribution_url)

# Open the application in your default browser
open $CLOUDFRONT_URL
```

Then:
1. Test user registration and login
2. Verify that the dashboard and other features are working correctly

## Local Development

For local development, you can run the frontend application with:

```bash
# Navigate to the frontend directory
cd src/frontend

# Install dependencies
npm install

# Start the development server
npm start
```

This will start the React development server on `http://localhost:3000`.

## Cleanup

To remove all deployed resources when they are no longer needed:

```bash
# Navigate to the Terraform directory
cd terraform/environments/dev

# Run the destroy command
terraform destroy
```

This will remove all AWS resources created for the application, including S3 buckets, Lambda functions, DynamoDB tables, and CloudFront distributions. 
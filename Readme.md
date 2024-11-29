

# Multi-Vendor Microservices Application

This project is a microservices-based multi-vendor application designed to handle user management, product listing, transactions, and notifications. The architecture is scalable and uses modern cloud technologies.

![Screenshot 2024-11-25 121642](https://github.com/user-attachments/assets/0e44be66-8891-4961-8b47-6fe6f45b4fef)


## Features

1. **User Service**: Handles user registration, authentication, and profile management.
2. **Product Service**: Manages product creation, updates, deletion, and retrieval.
3. **Transaction Service**: Processes orders, payments, and transaction logs.
4. **Notification Service**: Sends notifications to users via email or other channels.

## Tech Stack

- **Backend**: Node.js, Express.js
- **Cloud Technologies**: 
  - AWS CDK for infrastructure as code
  - Serverless Lambda for compute
  - SNS for notifications
  - CloudFront for content delivery
  - RDS for relational data storage
- **Database**: MongoDB, RDS
- **Communication**: REST APIs / RabbitMQ (for inter-service communication)
- **Containerization**: Docker
- **Authentication**: JWT / OAuth2

---

## Setup

### Prerequisites
- Node.js installed
- MongoDB instance running
- AWS CLI configured for deployment
- Docker installed (optional for local containerization)

### Service Paths
Each service is organized into its respective folder for ease of development and deployment:

1. **User Service**:
   ```bash
   cd services/user-service
   ```

2. **Product Service**:
   ```bash
   cd services/product-service
   ```

3. **Transaction Service**:
   ```bash
   cd services/transaction-service
   ```

4. **Notification Service**:
   ```bash
   cd services/notification-service
   ```

---

## Architecture Overview
The architecture leverages a cloud-native approach with the following components:

1. **AWS Lambda**: Serverless functions for executing core service logic.
2. **SNS**: Manages notifications across the application.
3. **RDS**: Relational data storage for transactions and other structured data.
4. **MongoDB**: Non-relational database for dynamic content such as products.
5. **CloudFront**: Content delivery network for serving assets quickly.

### Structural Diagram
![Screenshot 2024-11-25 123111](https://github.com/user-attachments/assets/0a734ebd-2d6c-40f6-b4d7-3bb03298a738)


## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

---


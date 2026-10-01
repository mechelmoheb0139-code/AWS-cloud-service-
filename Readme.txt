# AWS VProfile Multi-Tier Application — Manual Deployment → Terraform

## 📌 Project Overview

This project demonstrates the deployment of a **multi-tier Java web application on AWS**, starting with a **manual deployment using the AWS Management Console** and then progressing to **Terraform Infrastructure as Code (IaC)**.

The project was intentionally built in two phases:

### Phase 1 — Manual AWS Deployment

The complete application infrastructure was first created and configured manually through the **AWS Management Console**.

This phase focused on understanding:

* AWS networking
* EC2 instances
* Security Groups
* Amazon RDS
* Amazon ElastiCache
* Application-to-database connectivity
* Private communication between AWS services
* Linux server configuration
* Application deployment

### Phase 2 — Terraform Automation

After successfully deploying and testing the application manually, the next step is to reproduce and manage the infrastructure using **Terraform**.

This phase focuses on:

* Infrastructure as Code
* Terraform resource management
* Reproducible infrastructure
* Terraform variables and outputs
* Infrastructure validation and planning
* Automated provisioning
* Infrastructure lifecycle management

This approach provided practical experience with both **AWS infrastructure fundamentals** and **Infrastructure as Code**.

---

## 🏗️ Architecture

```text
                         Internet
                            │
                            ▼
                   ┌─────────────────┐
                   │   EC2 Instance  │
                   │ App + Tomcat    │
                   │     Java        │
                   └────────┬────────┘
                            │
          ┌─────────────────┼──────────────────┐
          │                 │                  │
          ▼                 ▼                  ▼
 ┌────────────────┐ ┌────────────────┐ ┌──────────────────┐
 │   Amazon RDS   │ │   EC2 Ubuntu   │ │   ElastiCache    │
 │     MySQL      │ │    RabbitMQ    │ │    Memcached     │
 └────────────────┘ └────────────────┘ └──────────────────┘
```

---

# 1️⃣ Phase 1 — Manual AWS Deployment

The first implementation was completed manually using the **AWS Management Console**.

The goal was to understand how each infrastructure component works and how the individual tiers communicate before introducing Infrastructure as Code.

---

## 1.1 AWS Environment

The application was deployed in:

```text
AWS Region: us-east-1
```

The existing AWS networking environment was reused where applicable.

---

## 1.2 Application Server

An **Ubuntu EC2 instance** was created to host:

```text
Java
Apache Tomcat
VProfile Application
```

The application server acts as the main application tier.

```text
Internet
    │
    ▼
EC2 Application Server
    │
    ├── Tomcat
    └── VProfile Application
```

---

## 1.3 RabbitMQ Server

A separate Ubuntu EC2 instance was created for RabbitMQ.

```text
Application EC2
       │
       │ Port 5672
       ▼
RabbitMQ EC2
```

RabbitMQ provides the messaging layer used by the application.

RabbitMQ was installed and configured directly on the Ubuntu EC2 instance rather than using Amazon MQ.

---

## 1.4 Amazon RDS MySQL

Amazon RDS was used as the database tier.

```text
Application EC2
      │
      │ Port 3306
      ▼
Amazon RDS MySQL
```

The application connects to the RDS endpoint using MySQL.

The application database used was:

```text
accounts
```

---

## 1.5 Amazon ElastiCache

Amazon ElastiCache for **Memcached** was used as the caching layer.

```text
Application EC2
      │
      │ Port 11211
      ▼
ElastiCache Memcached
```

The caching layer reduces repeated database operations and provides faster access to frequently used application data.

---

## 1.6 Security Groups

Security Groups were configured manually to control communication between the different application tiers.

The required communication paths were:

```text
Internet
   │
   ▼
Application EC2
   │
   ├──────────────► RDS MySQL : 3306
   │
   ├──────────────► RabbitMQ : 5672
   │
   └──────────────► Memcached : 11211
```

The backend services were configured to communicate with the application through the appropriate private networking paths.

---

## 1.7 Manual Configuration and Testing

After creating the AWS resources, the servers were configured manually.

### Application Server

Installed and configured:

```text
Ubuntu
Java
Apache Tomcat
VProfile Application
```

### RabbitMQ Server

Installed and configured:

```text
Ubuntu
RabbitMQ
```

### Database

Configured:

```text
Amazon RDS
MySQL
accounts database
```

### Cache

Configured:

```text
Amazon ElastiCache
Memcached
```

Connectivity between the different tiers was then tested.

---

# 2️⃣ Phase 2 — Terraform Infrastructure as Code

After successfully completing and testing the manual AWS deployment, Terraform was introduced to automate the infrastructure.

The objective was to move from:

```text
Manual AWS Console
        │
        ▼
Manually Created Infrastructure
```

to:

```text
Terraform
    │
    ▼
Infrastructure as Code
    │
    ▼
AWS Infrastructure
```

Terraform allows the infrastructure configuration to be version-controlled, reviewed, reproduced, and managed consistently.

---

# 3️⃣ Terraform Workflow

The Terraform workflow used in the second phase is:

```text
Terraform Configuration
          │
          ▼
    terraform init
          │
          ▼
   terraform validate
          │
          ▼
      terraform fmt
          │
          ▼
     terraform plan
          │
          ▼
     terraform apply
          │
          ▼
     AWS Resources
```

---

# 4️⃣ Terraform Initialization

Initialize the Terraform project:

```bash
terraform init
```

---

# 5️⃣ Validate Configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

# 6️⃣ Format Configuration

```bash
terraform fmt
```

---

# 7️⃣ Review Infrastructure Changes

Before applying the configuration:

```bash
terraform plan
```

This allows the infrastructure changes to be reviewed before they are applied to AWS.

---

# 8️⃣ Provision Infrastructure

```bash
terraform apply
```

Confirm the deployment:

```text
yes
```

Terraform then creates or manages the resources defined in the configuration.

---

# 9️⃣ Terraform Project Structure

```text
vprofile-terraform/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
│
├── vpc.tf
├── security-groups.tf
├── ec2.tf
├── rabbitmq.tf
├── elasticache.tf
│
├── user-data/
│   ├── app.sh
│   └── rabbitmq.sh
│
└── README.md
```

---

# 🔟 Infrastructure Verification

After deployment, Terraform outputs can be checked with:

```bash
terraform output
```

AWS resources can also be verified through the AWS CLI:

```bash
aws ec2 describe-instances
```

```bash
aws rds describe-db-instances
```

```bash
aws elasticache describe-cache-clusters
```

---

# 1️⃣1️⃣ Application Verification

SSH into the application server:

```bash
ssh -i app-key.pem ubuntu@<PUBLIC-IP>
```

Check Java:

```bash
java -version
```

Check Tomcat:

```bash
sudo systemctl status tomcat
```

Check listening ports:

```bash
sudo ss -lntp
```

---

# 1️⃣2️⃣ Backend Connectivity Testing

### RDS MySQL

```bash
nc -zv <RDS-ENDPOINT> 3306
```

### RabbitMQ

```bash
nc -zv <RABBITMQ-PRIVATE-IP> 5672
```

### Memcached

```bash
nc -zv <MEMCACHED-ENDPOINT> 11211
```

Successful connectivity confirms communication between the application and backend tiers.

---

# 1️⃣3️⃣ Access the Application

Once the application server and Tomcat are running:

```text
http://<APPLICATION-PUBLIC-IP>:8080
```

The VProfile application should then be accessible through the application server.

---

# 🔐 Security

Security considerations included:

* Restricting backend communication through Security Groups
* Using private connectivity between application tiers
* Restricting database access to the application layer
* Using private RabbitMQ connectivity
* Avoiding hardcoded AWS credentials
* Excluding Terraform state and sensitive files from Git

Recommended `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.pem
crash.log
```

---

# 🎯 Skills Demonstrated

### AWS

* Amazon EC2
* Amazon RDS
* Amazon ElastiCache
* Amazon VPC
* Security Groups
* IAM
* AWS networking

### Linux

* Ubuntu
* SSH
* Service management
* Network troubleshooting
* Application configuration

### Application

* Java
* Apache Tomcat
* MySQL
* RabbitMQ
* Memcached

### DevOps

* Terraform
* Infrastructure as Code
* Git
* GitHub
* Bash
* Infrastructure automation

---

# 📚 Project Learning Path

The main objective of this project was to understand the evolution from manually managed infrastructure to Infrastructure as Code.

```text
AWS Fundamentals
       │
       ▼
Manual AWS Deployment
       │
       ▼
Understand Networking
       │
       ▼
Configure Application Tiers
       │
       ▼
Test Connectivity
       │
       ▼
Terraform
       │
       ▼
Infrastructure as Code
       │
       ▼
Repeatable Deployment
```

This progression helped establish a practical understanding of **what Terraform is automating**, rather than using Terraform without first understanding the underlying AWS infrastructure.

---

# ⭐ Project Highlights

```text
✓ Multi-Tier Java Application
✓ Manual AWS Deployment
✓ AWS Management Console
✓ EC2 Application Server
✓ Apache Tomcat
✓ Amazon RDS MySQL
✓ RabbitMQ on Ubuntu EC2
✓ Amazon ElastiCache Memcached
✓ VPC Networking
✓ Security Groups
✓ Linux Administration
✓ Connectivity Testing
✓ Terraform Infrastructure as Code
✓ Infrastructure Automation
✓ Reproducible Infrastructure
```

---

# 👨‍💻 Author

**Michel**

Communication Engineer | Linux & Datacenter Administrator | DevOps Engineer

Technologies:

```text
AWS
Terraform
Linux
Docker
Kubernetes
Jenkins
Git
CI/CD
Infrastructure as Code
Cloud & DevOps
```

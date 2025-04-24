
#  Scalable Portfolio Deployment on AWS Using Terraform, NGINX, and Application Load Balancer

This project demonstrates an automated deployment of a portfolio website on AWS using **Terraform**. It launches **EC2 instances** with **NGINX**, sets up an **Application Load Balancer (ALB)** for better **scalability**, **high availability**, and smooth **traffic management**, and uses **IAM roles** to allow EC2 instances to **sync website files from an S3 bucket using AWS CLI**. The infrastructure follows **Infrastructure-as-Code (IaC)** practices for a clean, automated, and reusable deployment.


## 📚 Table of Contents


- [📌 Project Overview]
- [🧰 Technologies Used]
- [🛠️ Infrastructure Details]
- [🚀 Getting Started]
- [🧹 Cleanup]
- [ 🌍 Output ]
- [📸 Screenshots]
- [🧠 What I Learned]
- [📌 Future Improvements]

## 📌 Project Overview


- Deploys a **portfolio website** hosted on **EC2 instances** running **NGINX**
- Uses an **Application Load Balancer (ALB)** for routing and scalability
- **Website files are stored in an S3 bucket** and synced to EC2 on startup using **AWS CLI**
- EC2 instances assume an **IAM role** with S3 access to enable secure syncing
- Infrastructure is managed entirely via **Terraform**
## 🧰 Technologies Used

- **Terraform** (v1.x)
- **AWS EC2**
- **AWS Application Load Balancer**
- **NGINX**
- **Amazon S3**
- **IAM Roles**
- **AWS CLI**

## ## 🛠️ Infrastructure Details

| Resource              | Description                                                  |
|-----------------------|--------------------------------------------------------------|
| EC2 Instances         | Hosts NGINX to serve portfolio site                          |
| ALB                   | Routes incoming traffic to EC2 instances                     |
| Target Group          | Registers EC2 instances and routes traffic based on health   |
| S3 Bucket             | Stores website files (HTML, CSS, JS)                         |
| IAM Role              | Grants EC2 permission to access S3 bucket files                           |
| User Data Script      | Uses AWS CLI to sync S3 files to EC2 web root                |
| Security Groups       | Controls HTTP/SSH access                                     |

## 🧱 Step-by-Step Process

### ✅ Prerequisites

- Terraform installed
- Any Linux OS /Git Terminal

Let me walk you through what I actually did—step by step—and how the entire process was automated using Terraform.

### 1. Create a Unique S3 Bucket:

- Create an S3 bucket with a unique name to store website files.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/s3-bucket-source.png)

### 2. Upload Website Files to S3:

- Upload all your website files (HTML, CSS, JS, etc.) to the S3 bucket.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/s3-files-upload.png)

### 3. Create VPC and Public Subnets:

- Create a VPC with multiple availability zones (AZs).

- Set up public subnets in these AZs. Ensure that the front-end resources are publicly accessible.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-vpc.png)

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-subnet.png)

### 4. Set Up an Internet Gateway:

- Create an Internet Gateway to enable internet access for the resources in the public subnet.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-igw.png)

### 5. Create Route Table:

- Create a route table that routes traffic through the Internet Gateway.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-RT.png)


### 6. Associate Subnets with the Route Table:

- Associate the public subnets with the route table so that all resources in these subnets can access the internet.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-RT%20Association.png)

### 7. Generate an AWS Private Key for EC2:

- Create an AWS private key to enable SSH access to EC2 instances in private subnets.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-private%20key.png)


### 8. Launch EC2 Instances:

- Create EC2 instances with security groups that allow SSH (port 22) and HTTP (port 80) access.


![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-instamce.png)

### 9. Set Up EC2 IAM Role for S3 Access:

- Create an IAM role for the EC2 instances that allows them to access the S3 bucket and retrieve website files.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-IAM.png)

### 10 Install and Configure NGINX on EC2:

- Install AWS CLI on the EC2 instance using a script. This allows the instance to run AWS commands, such as syncing S3 bucket files with the NGINX web directory. 

- Write a script to install and configure NGINX on the EC2 instances.

- Sync the files from the S3 bucket to the NGINX server so the website is served correctly.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-nginx.png)

### 11. Configure Target Groups:

- Create a target group for the EC2 instances.

- Register the instances in this group to handle web traffic.

![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-TG.png)

### 12. Deploy an Application Load Balancer (ALB):

- **Create the ALB:** Set up an Application Load Balancer using public subnets so it can receive traffic from the internet.
- **Add a Listener:** Create a listener on port 80 to handle incoming HTTP requests.
- **Forward Traffic:** Link the listener to a target group so the ALB can forward requests to your EC2 instances.


![App Screenshot](https://github.com/AvinashSaxena17/terraform-aws-nginx-portfolio-alb/blob/91c50f3308c8164ef698f6904d7dc083c766c244/ec2%20images/ec2-ALB.png)



### 🔧 Deployment Steps

```bash
# 1. Clone the repository
git clone https://github.com/your-username/terraform-aws-nginx-portfolio-alb.git
cd terraform-aws-nginx-portfolio-alb

# 2. Initialize Terraform
terraform init

# 3. Review the plan
terraform plan

# 4. Apply the infrastructure
terraform apply

```


## 🧹 Cleanup

```bash
# Destroy all Terraform-managed infrastructure to avoid ongoing costs
terraform destroy
```
## 🌍 Output:

After a successful terraform apply :

1. ALB DNS NAME : Public URL where your portfolio website can be accessed through the Application Load Balancer.

2. Paste this URL into your browser to see your deployed portfolio live.


## [📸 website-accessed-via-aws-alb-dns]

![App Screenshot](https://github.com/AvinashSaxena17/iac-aws-portfolio-hosting/blob/246578d388fde92b6de371bbec784e5aca16b640/ALB%20DNS.png)

## 🧠 What I Learned

- Automating EC2 and ALB setup using Terraform modules

- Using IAM roles to securely access S3 from EC2

- Syncing contents to NGINX from S3 to ec2  using AWS CLI

- Managing production-like deployments using Infrastructure as Code

- Building scalable and highly available architecture on AWS

## 📌 Future Improvements

- Add SSL using ACM and redirect HTTP to HTTPS

- Integrate Route 53 to map a custom domain

- Use GitHub Actions for CI/CD pipeline

- Enable CloudWatch logs and alarms








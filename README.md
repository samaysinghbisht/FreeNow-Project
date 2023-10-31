# **Project Setup Guide**

## **Pre-Requisites:**
Ensure that you have the following tools installed before proceeding:
- Docker 
- Terraform

## **Application Overview:**
This project includes a simple Flask application with functionalities such as inserting data into an RDS database and an S3 bucket, coupled with a user interface for data entry.

## **Building the Docker Image:**

1. Navigate to the `app` directory from the project root.
2. Build the Docker image by running:
   ```bash
   docker build -t <image-name> .
   ```
   > **Note:** If you are using a Mac with an M1 chip, include the `--platform linux/amd64` argument to ensure compatibility with the AMI used in the EC2 instance.
3. Push the Docker image to a repository:
   ```bash
   docker push <image-name>
   ```

## **Provisioning the Infrastructure:**
Before starting the provisioning process, ensure you have created an AWS key pair named "private-key.pem" and saved it in the `terraform` folder.

1. Navigate to the `terraform` directory.
2. Initialize the Terraform configuration:
   ```bash
   terraform init
   ```
3. Ensure code quality by formatting the Terraform code:
   ```bash
   terraform fmt
   ```
4. Validate the Terraform configuration:
   ```bash
   terraform validate
   ```
5. Review the execution plan to understand the resources that will be created or modified:
   ```bash
   terraform plan
   ```
6. Apply the changes to deploy the infrastructure:
   ```bash
   terraform apply
   ```

After successfully deploying the infrastructure, access the application through the Application Load Balancer’s DNS record. Ensure that the URL starts with `http://`.

## **Custom Domain Setup:**
To make the application accessible at "https://mysimplewebsite.playground.free-now.com/":
- Move `Route53.tf` to the terraform directory and execute the Terraform commands (`init`, `validate`, `plan`, `apply`) again.

## **Website Accessibility:**
To restrict access to the application through the custom domain only, modify the ingress configuration in `sg.tf` for the Application Load Balancer.

## **Scaling:**
The configuration includes load balancing. For enhanced scalability, consider adding Auto-Scaling Groups (ASGs) to automatically adjust the number of EC2 instances.

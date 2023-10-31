variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  default     = "samay-aws"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "freenow1234"
}

variable "db_allocated_storage" {
  description = "Allocated storage size for DB"
  default     = 20
}

variable "db_instance_class" {
  description = "Instance class for DB"
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "Database Name"
  default     = "freenowDB"
}

variable "username" {
  description = "Database Username"
  default     = "dbuser"
}

variable "password" {
  description = "Database Password"
  default     = "dbpassword"
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-04376654933b081a7"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

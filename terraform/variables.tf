variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "application_port" {
  description = "Application port"
  type        = number
  default     = 5000
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "8byte-devops-app"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "Public subnet A CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "Public subnet B CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "Private subnet A CIDR"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "Private subnet B CIDR"
  type        = string
  default     = "10.0.12.0/24"
}

variable "availability_zone_a" {
  description = "Availability Zone A"
  type        = string
  default     = "ap-south-1a"
}

variable "availability_zone_b" {
  description = "Availability Zone B"
  type        = string
  default     = "ap-south-1b"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "8byte-devops-app"
}

variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "byte8-postgres"
}

variable "rds_database_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "eightbyte"
}

variable "rds_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "postgres"
}

variable "rds_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "rds_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "instance_type" {
  description = "EC2 instance type for Linux instance"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "web-linux"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}
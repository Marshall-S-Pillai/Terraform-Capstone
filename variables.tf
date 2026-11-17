variable "aws_region" {
  description = "AWS region for this environment."
  type        = string
  default     = "us-east-1"
}
variable "project_name" {
  description = "Prefix for resource names."
  type        = string
  default     = "terraform-capstone"
}
variable "environment" {
  description = "Environment name; use dev or prod."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}
variable "allowed_ssh_cidr" {
  description = "Your public IPv4 CIDR, e.g. 203.0.113.10/32."
  type        = string
  default     = "127.0.0.1/32"
  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

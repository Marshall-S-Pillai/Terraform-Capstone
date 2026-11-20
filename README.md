# Terraform Capstone — AWS Infrastructure

A Terraform project demonstrating AWS infrastructure provisioning, remote state, Registry modules, workspaces, variables, outputs, and GitHub Actions.

## Architecture

- VPC: 10.30.0.0/16
- Public subnet with Internet Gateway and default route
- Security group: HTTP/80 public; SSH/22 restricted to your configured IP CIDR
- EC2: Amazon Linux 2023, created through the Terraform Registry module `terraform-aws-modules/ec2-instance/aws`
- Terraform remote state stored in a manually created S3 bucket

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured with credentials/role that can manage the resources
- A dedicated S3 bucket for Terraform state, created manually
- GitHub repository secrets: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

## Remote state bucket

Create your S3 bucket manually before running Terraform. Update the bucket name in `backend.tf` to your bucket name. Enable versioning and block public access on the bucket. This bucket is used only for Terraform state; Terraform does not create or destroy it.

## Local deployment

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit allowed_ssh_cidr to your public IP /32
terraform fmt -recursive
terraform init
terraform validate
terraform workspace select dev || terraform workspace new dev
terraform plan -var="environment=dev"
terraform apply -var="environment=dev"
```

## GitHub Actions

Two manually triggered workflows are available under Actions:

- `Terraform Create`: selects dev or prod, validates, plans, and applies infrastructure.
- `Terraform Destroy`: selects dev or prod and destroys resources in that workspace.

Configure the repository secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. The S3 state bucket must already exist and its name must be configured in `backend.tf`.


# Terraform Capstone — AWS Infrastructure

A clean Terraform project demonstrating AWS infrastructure provisioning, remote state, Registry modules, workspaces, variables, outputs, and CI validation.

## Architecture

- VPC: 10.30.0.0/16
- Public subnet with Internet Gateway and default route
- Security group: HTTP/80 public; SSH/22 restricted to your configured IP CIDR
- EC2: Amazon Linux 2023, created through the Terraform Registry module `terraform-aws-modules/ec2-instance/aws`
- S3 application bucket: versioning, AES256 encryption, and public-access blocking
- S3 remote backend with native lockfile support

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured with credentials/role that can manage the resources
- A dedicated S3 bucket for Terraform state

## Bootstrap remote state

The backend bucket must exist before `terraform init`. Create a globally unique bucket in us-east-1, enable versioning, and block public access. Replace the placeholder bucket in `backend.tf`. Keep this state bucket separate from the application bucket managed by this project.

Example:
```bash
aws s3api create-bucket --bucket YOUR-UNIQUE-STATE-BUCKET --region us-east-1
aws s3api put-bucket-versioning --bucket YOUR-UNIQUE-STATE-BUCKET --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket YOUR-UNIQUE-STATE-BUCKET --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

## Deploy

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit allowed_ssh_cidr to your public IP /32
terraform fmt -recursive
terraform init
terraform validate
terraform workspace new dev   # if it does not exist; otherwise select dev
terraform workspace select dev
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

For production, select/create the `prod` workspace. Terraform's S3 backend stores non-default workspaces under its workspace key prefix. Review each plan carefully before applying.

## GitHub Actions

The workflow in `.github/workflows/terraform.yml` runs fmt, init, validate, workspace selection, and plan on manual dispatch. Configure the repository secret `AWS_ROLE_ARN` for GitHub OIDC and configure the role trust policy for this repository. The workflow does not auto-apply infrastructure.

## Cleanup

Run `terraform destroy` from the intended workspace after reviewing the plan. Empty the application bucket first. Do not delete the remote state bucket until all state is safely retired.

## Submission evidence

Capture terminal screenshots for init, fmt, validate, workspace list, plan, apply and outputs; capture AWS console screenshots for EC2, VPC, and S3 resources. A successful code commit alone does not prove a live deployment.

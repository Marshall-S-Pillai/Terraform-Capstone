# Create a dedicated S3 state bucket before terraform init.
# Replace the placeholder with your globally unique bucket name.
terraform {
  backend "s3" {
    bucket       = "powertool2030"
    key          = "terraform-capstone/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}
output "ec2_instance_id" {
  description = "EC2 instance ID."
  value       = module.ec2_instance.id
}
output "ec2_public_ip" {
  description = "EC2 public IPv4 address."
  value       = module.ec2_instance.public_ip
}
output "website_url" {
  description = "HTTP test URL."
  value       = "http://${module.ec2_instance.public_ip}"
}

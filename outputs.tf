output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.demo_instance.id
}

output "instance_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = aws_instance.demo_instance.public_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "s3_bucket_id" {
  description = "ID of the created S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = module.security_group.security_group_id
}

output "random_suffix" {
  description = "Random suffix used for resource naming"
  value       = random_string.suffix.result
}

output "instance_name" {
  description = "Random pet name used for the instance"
  value       = random_pet.instance.id
} 
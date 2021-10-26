output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_public_subnet_ids" {
  description = "IDs of the VPC's public subnets"
  value       = aws_subnet.subnet_public.*.id
}

output "vpc_private_subnet_ids" {
  description = "IDs of the VPC's private subnets"
  value       = aws_subnet.subnet_private.*.id
}

output "eip_id" {
  description = "Elastic IP ID"
  value       = aws_eip.eip.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_eip.eip.public_ip
}
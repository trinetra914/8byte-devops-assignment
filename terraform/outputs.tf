output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "application_url" {
  value = "http://${aws_instance.app.public_ip}:5000"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "rds_port" {
  value = aws_db_instance.postgres.port
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "alb_url" {
  description = "Application URL through the Application Load Balancer"
  value       = "http://${aws_lb.app.dns_name}"
}
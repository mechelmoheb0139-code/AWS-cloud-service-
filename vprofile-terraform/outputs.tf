# ==========================================
# VPC
# ==========================================

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}


# ==========================================
# Application EC2
# ==========================================

output "app_instance_id" {
  description = "Application EC2 instance ID"
  value       = aws_instance.app.id
}

output "app_public_ip" {
  description = "Application EC2 public IP"
  value       = aws_instance.app.public_ip
}

output "app_private_ip" {
  description = "Application EC2 private IP"
  value       = aws_instance.app.private_ip
}


# ==========================================
# RabbitMQ EC2
# ==========================================

output "rabbitmq_instance_id" {
  description = "RabbitMQ EC2 instance ID"
  value       = aws_instance.rabbitmq.id
}

output "rabbitmq_public_ip" {
  description = "RabbitMQ EC2 public IP"
  value       = aws_instance.rabbitmq.public_ip
}

output "rabbitmq_private_ip" {
  description = "RabbitMQ EC2 private IP"
  value       = aws_instance.rabbitmq.private_ip
}


# ==========================================
# RDS
# ==========================================

output "rds_endpoint" {
  description = "Existing RDS MySQL endpoint"
  value       = "project-db.cy3uiesg2ihb.us-east-1.rds.amazonaws.com"
}

output "rds_port" {
  description = "Existing RDS MySQL port"
  value       = 3306
}

# ==========================================
# ElastiCache
# ==========================================

output "memcached_endpoint" {
  description = "Memcached endpoint"
  value       = aws_elasticache_cluster.memcached.configuration_endpoint
}

output "memcached_port" {
  description = "Memcached port"
  value       = aws_elasticache_cluster.memcached.port
}

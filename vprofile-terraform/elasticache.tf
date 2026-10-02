# ==========================================
# ElastiCache Subnet Group
# ==========================================

resource "aws_elasticache_subnet_group" "memcached" {
  name = "${var.project_name}-memcached-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}


# ==========================================
# ElastiCache Memcached
# ==========================================

resource "aws_elasticache_cluster" "memcached" {
  cluster_id = "${var.project_name}-memcached"

  engine = "memcached"

  node_type       = "cache.t3.micro"
  num_cache_nodes = 1

  port = 11211

  subnet_group_name = aws_elasticache_subnet_group.memcached.name

  security_group_ids = [
    aws_security_group.memcached.id
  ]
  transit_encryption_enabled = false

  tags = {
    Name = "${var.project_name}-memcached"
  }
}

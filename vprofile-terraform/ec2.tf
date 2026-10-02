# ==========================================
# Application EC2
# ==========================================

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  key_name = var.key_name

  user_data = file("${path.module}/userdata-app.sh")

  tags = {
    Name = "${var.project_name}-app01"
  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      user_data
    ]
  }

}

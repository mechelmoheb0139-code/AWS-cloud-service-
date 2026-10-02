# ==========================================
# Ubuntu AMI for RabbitMQ
# ==========================================

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "image-id"
    values = ["ami-0fb0b230890ccd1e6"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


# ==========================================
# RabbitMQ EC2
# ==========================================

resource "aws_instance" "rabbitmq" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.rabbitmq.id
  ]

  key_name = var.key_name


  user_data = templatefile(
    "${path.module}/userdata-rabbitmq.sh",
    {
      rabbitmq_username = var.rabbitmq_username
      rabbitmq_password = var.rabbitmq_password
    }
  )

  tags = {
    Name = "${var.project_name}-rmq01"
  }
  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      user_data
    ]
  }



}

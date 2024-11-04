resource "aws_security_group" "nginx-lb" {
  name        = "${var.environment}-nginx-lb-sg"
  description = "Security group for nginx load balander"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_22_cidr]
  }
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.environment}-nginx-lb-sg"
  }
}

resource "aws_instance" "nginx-lb" {
  ami           = var.aws_ami
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx-lb.id]
  key_name               = var.key_name
  user_data              = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo '${var.config}' > /etc/nginx/nginx.conf
              systemctl restart nginx
              EOF

  tags = {
    Name = "${var.environment}-nginx-lb"
  }
}


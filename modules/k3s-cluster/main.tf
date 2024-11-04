resource "aws_security_group" "k3s" {
  name        = "${var.environment}-k3s-sg"
  description = "Security group for k3s cluster"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = [var.ingress_app_cidr]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cluster_cidr]
  }
  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [var.ingress_cluster_cidr]
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_22_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-k3s-sg"
  }
}



resource "aws_instance" "k3s_server" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.key_name
  user_data              = <<-EOF
   #!/bin/bash
    apt update
    curl -sfL https://get.k3s.io | K3S_TOKEN=${var.token} sh -
    echo '${var.manifest}' > /tmp/manifest.yaml
    k3s kubectl apply -f /tmp/manifest.yaml

  EOF
  tags = {
    Name = "${var.environment}-k3s-server"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "k3s_worker" {
  depends_on             = [aws_instance.k3s_server]
  count                  = var.node_count - 1
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.key_name
  user_data              = <<-EOF
      #!/bin/bash
      apt update
      curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_server.private_ip}:6443 K3S_TOKEN=${var.token} sh -s -
  EOF


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-k3s-worker-${count.index + 1}"
  }
}

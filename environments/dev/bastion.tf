resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-bastion-sg"
  }

}

locals {

  bastion_user     = "ubuntu"
  private_key_path = "~/.ssh/id_rsa"
}
resource "aws_instance" "bastion" {
  ami                    = local.aws_ami
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.kp.key_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  provisioner "file" {
    source      = local.private_key_path
    destination = "/home/ubuntu/.ssh/id_rsa"


    connection {
      type        = "ssh"
      user        = local.bastion_user
      private_key = file(local.private_key_path)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = ["chmod 600 /home/ubuntu/.ssh/id_rsa"]
    connection {
      type        = "ssh"
      user        = local.bastion_user
      private_key = file(local.private_key_path)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "${var.environment}-bastion"
  }

}
locals {
  bastion_host = aws_instance.bastion.public_ip
}

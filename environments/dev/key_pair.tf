resource "aws_key_pair" "kp" {
  key_name   = "kp"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "public_ip" {
  value = aws_instance.nginx-lb.public_ip
}
output "public_dns" {
  value = aws_instance.nginx-lb.public_dns
}

output "private_ip" {
  value = aws_instance.nginx-lb.private_ip
}

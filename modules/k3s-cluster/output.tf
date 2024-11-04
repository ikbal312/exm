output "server_ip" {
  value = aws_instance.k3s_server.private_ip
}

output "agent_ips" {
  value = aws_instance.k3s_worker.*.private_ip
}

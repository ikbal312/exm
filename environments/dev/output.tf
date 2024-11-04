output "bastion" {
  value = aws_instance.bastion.public_ip
}
output "load_balancer_public_ip" {
  value = module.nginx-lb.public_ip
}
output "cluster_server_ip" {
  value = module.k3s_cluster.server_ip
}
output "cluster_agent_ips" {
  value = module.k3s_cluster.agent_ips
}

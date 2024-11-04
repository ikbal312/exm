locals {
  server_ip  = module.k3s_cluster.server_ip
  agent_ips  = module.k3s_cluster.agent_ips
  agent_port = 30001
}

module "nginx-lb" {
  depends_on      = [module.k3s_cluster]
  source          = "../../modules/nginx-lb"
  environment     = var.environment
  aws_ami         = local.aws_ami # ubuntu
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  vpc_id          = aws_vpc.main.id
  key_name        = aws_key_pair.kp.key_name
  ingress_22_cidr = aws_subnet.public_subnet.cidr_block
  config = templatefile("./config/nginx/nginx.conf.tftpl", {
    AppServers = local.agent_ips
    Port       = local.agent_port
  })
}


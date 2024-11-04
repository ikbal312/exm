locals {
  k3s_manifest_path = "./config/k3s_manifest/nginx.yaml"
}
module "k3s_cluster" {
  source               = "../../modules/k3s-cluster"
  vpc_id               = aws_vpc.main.id
  environment          = var.environment
  aws_ami              = local.aws_ami
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet.id
  key_name             = aws_key_pair.kp.key_name
  node_count           = 3
  token                = var.k3s_token
  manifest             = file(local.k3s_manifest_path)
  ingress_22_cidr      = aws_subnet.public_subnet.cidr_block
  ingress_app_cidr     = aws_subnet.public_subnet.cidr_block
  ingress_cluster_cidr = aws_subnet.private_subnet.cidr_block
}

locals {
  server_private_ip = module.k3s_cluster.server_ip
}

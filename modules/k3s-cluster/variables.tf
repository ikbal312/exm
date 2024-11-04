variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  type = string
}
variable "aws_ami" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "subnet_id" {
}

variable "node_count" {
  type = number
}
variable "key_name" {
  type = string
}
variable "token" {
  type = string
}

variable "manifest" {
  type = string
}
variable "ingress_cluster_cidr" {
  type = string
}
variable "ingress_22_cidr" {
  type = string
}
variable "ingress_app_cidr" {
  type = string
}

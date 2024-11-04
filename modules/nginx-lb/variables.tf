variable "environment" {
  type = string
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
  type = string
}

variable "key_name" {
  type = string
}


variable "config" {
  type = string
}
variable "ingress_22_cidr" {
  type = string
}

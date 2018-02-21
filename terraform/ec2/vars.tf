variable "aws_region" {
  description = "AWS region in which to deploy resources"
  type = "string"
  default = "us-west-2"
}

variable "inst_name" {
  description = "What to name your instance"
  type = "string"
  default = "testingk"
}

variable "inst_2_name" {
}

variable "inst_type" {
  description = "Size of EC2 instance to launch"
  type = "string"
  default = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for image on which your instance is based"
  type = "string"
  default = "ami-123456"
}

variable "num_nodes" {
  description = "How many nodes you would like to deploy"
  type = "string"
  default = "1"
}

variable "ebs_del_term" {
  description = "Whether or not to delete the EBS volume running under your EC2 instance when the instance is terminated"
  type = "string"
  default = "true"
}

variable "route_53_zone_id" {
  description = "ID of the Route53 hosted zone in which to create a DNS record for EC2 instance"
  type = "string"
  default = "123456"
}

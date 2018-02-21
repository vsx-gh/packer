variable "aws_region" {
  description = "Region in which to deploy resource(s)"
  default = "us-west-2"
}

// VPC vars
variable "envname" {}

variable "cidr" {}

variable "aws_vpc_name" {
  description = "Name for VPC"
  default = "test_vpc"
}

variable "vpc_pub_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}

variable "vpc_azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "bastion_ips" {
  description = "IP addresses of jumpboxes"
  type = "string"
  default = ""
}

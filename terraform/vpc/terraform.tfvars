tags {
  "Terraform" = "true"
  "Environment" = "vsx-packer-img"
}
envname = "vsx-packer-img"
aws_vpc_name = "packer_imaging"
cidr = "10.16.0.0/16"
aws_region = "us-west-2"
vpc_azs = ["us-west-2a"]
bastion_ips = "68.81.88.145/32"
vpc_pub_subnets = ["10.16.254.0/24"]
enable_dns_hostnames = "true"
enable_dns_support = "true"

/*
Environment:       packer_build
Author:            vsx-gh
Created:           20180208

Environment creates the following:
- EC2 instance(s)
*/

provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc_netstate" {
  backend = "local"

  config {
    path = "${path.module}/../vpc/terraform.tfstate"
  }
}

resource "aws_instance" "jumpbox-USW2A" {
  ami = "${var.ami_id}"
  instance_type = "${var.inst_type}"
  subnet_id = "${data.terraform_remote_state.vpc_netstate.public_subnets[0]}"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc_netstate.main_sec_grp_id}"]
  count = "${var.num_nodes}"

  root_block_device {
    delete_on_termination = "${var.ebs_del_term}"
  }

  tags {
    "Name" = "${var.inst_name}-${count.index}"
    "Environment" = "vsx-aws_EC2_Testing"
    "Terraform" = "true"
  }
}

resource "aws_eip" "jumpbox-USW2A_EIP" {
  instance = "${aws_instance.jumpbox-USW2A.id}"
}

resource "aws_route53_record" "jump_A_REC" {
  zone_id = "${var.route_53_zone_id}"
  name = "herman.sickletech.com."
  type = "A"
  ttl = "300"
  records = ["${aws_eip.jumpbox-USW2A_EIP.public_ip}"]
}

resource "aws_instance" "jumpbox-USW2A_2" {
  ami = "ami-0a117025fbfc15769"
  instance_type = "${var.inst_type}"
  subnet_id = "${data.terraform_remote_state.vpc_netstate.public_subnets[0]}"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc_netstate.main_sec_grp_id}"]
  count = "${var.num_nodes}"

  root_block_device {
    delete_on_termination = "${var.ebs_del_term}"
  }

  tags {
    "Name" = "${var.inst_2_name}-${count.index}"
    "Environment" = "vsx-aws_EC2_Testing"
    "Terraform" = "true"
  }
}

resource "aws_eip" "jumpbox-USW2A_EIP_2" {
  instance = "${aws_instance.jumpbox-USW2A_2.id}"
}

resource "aws_route53_record" "jump_A_REC_2" {
  zone_id = "${var.route_53_zone_id}"
  name = "wolfcastle.sickletech.com."
  type = "A"
  ttl = "300"
  records = ["${aws_eip.jumpbox-USW2A_EIP_2.public_ip}"]
}

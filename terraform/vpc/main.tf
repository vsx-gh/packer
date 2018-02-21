/*
Environment:       packer_build
Author:            vsx-gh
Created:           20180208

Environment creates the following:
- VPC
- Public subnet
- Internet gateway (IGW)
- Security groups
- Network ACLs (NACLs)
- Routes
- Route tables and associations
*/

provider "aws" {
  region = "${var.aws_region}"
}

/*
Start VPC config
*/
resource "aws_vpc" "packer_vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.envname)))}"
}

resource "aws_internet_gateway" "packer_igw" {
  vpc_id = "${aws_vpc.packer_vpc.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-IGW", var.envname)))}"
}

resource "aws_route_table" "packer_pub" {
  vpc_id           = "${aws_vpc.packer_vpc.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]
  tags             = "${merge(var.tags, map("Name", format("R-%s-PUB", var.envname)))}"
}

resource "aws_route" "public_igw" {
  route_table_id         = "${aws_route_table.packer_pub.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.packer_igw.id}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.packer_vpc.id}"
  cidr_block        = "${var.vpc_pub_subnets[count.index]}"
  availability_zone = "${var.vpc_azs[count.index]}"
  count             = "${length(var.vpc_pub_subnets)}"
  tags              = "${merge(var.tags, map("Name", format("S-%s-PUB-%s", var.envname, element(var.vpc_azs, count.index))))}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.vpc_pub_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.packer_pub.id}"
}


/*
Start security group config
*/
resource "aws_security_group" "SG-Inbound-All-Allow-SSH-Jump" {
    name = "SG-Inbound-All-Allow-SSH-Jump-${var.aws_vpc_name}"
    description = "Allow SSH traffic from jumpboxes"
    vpc_id = "${aws_vpc.packer_vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "6"
        cidr_blocks = ["${var.bastion_ips}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "SG-Inbound-All-Allow-SSH-Jump-${var.envname}"
    }
}


/*
Start netsec (NACL) config
*/
resource "aws_network_acl" "ACL-Packer_Img-PUB" {
  vpc_id = "${aws_vpc.packer_vpc.id}"
  subnet_ids = ["${aws_subnet.public.id}"]

    tags {
      "Name" = "NACL-${var.aws_vpc_name}-PUB"
      "Environment" = "${var.envname}"
      "Terraform" = "true"
    }
}

resource "aws_network_acl_rule" "ACL-Packer_Img-PUB-I-SSH" {
    network_acl_id = "${aws_network_acl.ACL-Packer_Img-PUB.id}"
    rule_number = 100
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_block = "${var.bastion_ips}"
    rule_action = "allow"
}

resource "aws_network_acl_rule" "ACL-Packer_Img-PUB-I-RETURNTCP" {
    // Rule allows established connections back in; handle with care
    network_acl_id = "${aws_network_acl.ACL-Packer_Img-PUB.id}"
    rule_number = 200
    protocol = "tcp"
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    rule_action = "allow"
}

resource "aws_network_acl_rule" "ACL-Packer_Img-PUB-I-RETURNUDP" {
    // Rule allows established connections back in; handle with care
    network_acl_id = "${aws_network_acl.ACL-Packer_Img-PUB.id}"
    rule_number = 300
    protocol = "udp"
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    rule_action = "allow"
}

resource "aws_network_acl_rule" "ACL-Packer_Img-PUB-E" {
    network_acl_id = "${aws_network_acl.ACL-Packer_Img-PUB.id}"
    rule_number = 400
    egress = true
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_block = "0.0.0.0/0"
    rule_action = "allow"
}

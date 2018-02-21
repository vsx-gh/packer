/*output "vpc_name" {
  value = "${aws_vpc.mod.name}"
}*/

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.packer_vpc.id}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.packer_pub.*.id}"]
}

output "main_sec_grp_id" {
  value = "${aws_security_group.SG-Inbound-All-Allow-SSH-Jump.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.packer_igw.id}"
}

output "vpc_cidr_blk" {
  value = "${aws_vpc.packer_vpc.cidr_block}"
}

output "public_subnets_cidr" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}

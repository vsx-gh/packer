output "ec2_pub_ips" {
  value = ["${aws_instance.jumpbox-USW2A.*.public_ip}"]
}

output "ec2_eip" {
  value = "${aws_eip.jumpbox-USW2A_EIP.id}"
}

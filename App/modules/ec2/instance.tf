resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance}"
  key_name      = "${var.key_pair}"
  vpc_security_group_ids = ["${var.sg_id}"]
  subnet_id                = "${var.subnet_id}"
  associate_public_ip_address = "${var.pub_ip_want}"
  tags = {
    Name = "${var.name}"
  }
}

output "pub_id" {
  value = "${aws_instance.web.public_ip}"
}
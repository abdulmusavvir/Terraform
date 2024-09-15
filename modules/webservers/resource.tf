resource "aws_instance" "terraform-instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
}

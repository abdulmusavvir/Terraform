resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/id_rsa.pub")
}


resource "aws_instance" "terraform-instance" {
  ami                    = var.ami-id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.terraform-key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  user_data              = <<-EOF
                  #!/bin/bash
                  sudo apt-get update
                  sudo apt-get install nginx -y
                  sudo echo "Hi AbdulMusavvir Rohe" > /var/www/html/index.nginx-debian.html
                  EOF
  tags = {
    Name = "tf-instance"
  }
  # provisioner "file" {
  #   source      = "./readme.md"
  #   destination = "/tmp/readme.md"
  #   connection {
  #     user        = "ubuntu"
  #     private_key = file("${path.module}/id_rsa")
  #     type        = "ssh"
  #     host        = self.id
  #   }
  # }

  provisioner "local-exec" {
    command     = "Get-Date > completed.txt"
    interpreter = ["PowerShell", "-Command"]

  }


}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = var.port_numbers
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks

    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

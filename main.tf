provider "aws" {
  region = "us-east-1"
}


variable "server_port" {
description = "The port the server will use HTTP requests"
type = number
default = 8080
}

resource "aws_security_group" "myinstance" {
  name = "my_secgroup"
  

  ingress {
    from_port = var.server_port
    to_port   = var.server_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



resource "aws_instance" "example" {
  ami           =  "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.myinstance.id]

user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true


    tags = {
    Name = "tf-example1"
  }
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}

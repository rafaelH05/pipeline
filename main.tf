terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "vm1" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"

  key_name = aws_key_pair.ssh-clave.key_name

  vpc_security_group_ids = [
    aws_security_group.vm1-sg.id
  ]

  subnet_id = aws_subnet.subnet_reservas.id
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install mariadb-client -y
              EOF

  tags = {
    Name = "vm1"
  }
}

resource "aws_key_pair" "ssh-clave" {
  key_name   = "ssh-clave"
  public_key = file(var.vm1_key)
}


resource "aws_instance" "vm2" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl start nginx
              EOF
  subnet_id = aws_subnet.subnet_reservas.id
  key_name = aws_key_pair.ssh-clave.key_name
  vpc_security_group_ids = [ 
    aws_security_group.vm2-sg.id
   ]

  private_ip = "10.0.1.102"

  tags = {
    Name = "vm2"
  }
}

resource "aws_instance" "vm_monitor" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  
  private_ip = "10.0.1.103"

  vpc_security_group_ids = [ aws_security_group.vm_monitor-sg.id ]
  subnet_id = aws_subnet.subnet_reservas.id
  key_name = aws_key_pair.ssh-clave.key_name

  tags = {
    Name = "Monitoreo"
  }
}

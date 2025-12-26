resource "aws_security_group" "vm2-sg" {
  name = "SG-VM2"
  description = "Permite solo el acceso desde vm1"
  vpc_id = aws_vpc.red_reservas.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}

resource "aws_security_group" "db-sg" {
  name = "db-sg"
  description = "Permite solo acceso desde vm1 y vm2 por el puerto 3306"
  vpc_id = aws_vpc.red_reservas.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "vm1-sg" {
  name        = "vm1-sg"
  description = "Security group SSH HTTP"
  vpc_id      = aws_vpc.red_reservas.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vm_monitor-sg" {
  name = "vm monitor sg"
  description = "Permite el acceso a las maquinas vm1 y vm2"
  vpc_id = aws_vpc.red_reservas.id

  ingress {
    to_port = 9090
    from_port = 9090
    protocol = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  ingress {
    to_port = 3000
    from_port = 3000
    protocol = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
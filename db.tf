resource "aws_db_instance" "db_principal" {
  engine = "mariadb"
  engine_version = "11.4.8"
  instance_class = "db.t4g.micro"
  
  allocated_storage = 20
  storage_type = "gp2"

  db_name = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name = aws_db_subnet_group.grupo_db.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]

  skip_final_snapshot = true
  publicly_accessible = false
}
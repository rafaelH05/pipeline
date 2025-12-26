output "public_id_vm1" {
  value = aws_instance.vm1.public_ip
}
output "db_endpoint" {
  value = aws_db_instance.db_principal.endpoint
}
output "rds_endpoint"{
  value = aws_db_instance.db_principal.address
}
output "vm1_ip" {
  value = aws_instance.vm1.public_ip
}
output "vm2_private_ip" {
  value = aws_instance.vm2.private_ip
}
output "vm3_private_ip" {
  value = aws_instance.vm_monitor.private_ip
}

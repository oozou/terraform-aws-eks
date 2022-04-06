output "private_ip" {
  description = "bootstrap module private ip"
  value       = aws_instance.this.private_ip
}

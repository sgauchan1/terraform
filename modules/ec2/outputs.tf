output "public_ip" {
  value = aws_instance.sandipWeb.public_ip
}

output "private_ip" {
  value = aws_instance.sandipWeb.private_ip
}

output "security_grp_id" {
  value = aws_security_group.ssh.id
}
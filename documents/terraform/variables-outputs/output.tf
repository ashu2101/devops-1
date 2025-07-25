output "instance_name" {
  value = aws_instance.web.tags["Name"]
}

output "instance_id" {
  value = aws_instance.web.id
}

output "open_ports" {
  value = var.ports
}

output "printingDetails" {
  value = aws_instance.terraform-instance.instance_state
}

output "Key-name" {
  value = aws_key_pair.terraform-key.key_name
}

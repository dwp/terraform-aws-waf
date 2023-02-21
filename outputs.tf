output "wafregional_web_acl_id" {
  value       = aws_wafregional_web_acl.acl.id
  description = "The ID of the regional Web ACL."
}

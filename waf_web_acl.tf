resource "aws_wafregional_web_acl" "acl" {
  name        = local.waf_name
  metric_name = local.waf_name
  tags        = var.tags

  logging_configuration {
    log_destination = aws_kinesis_firehose_delivery_stream.extended_s3_stream.arn
  }

  default_action {
    type = var.default_action
  }

  dynamic "rule" {
    for_each = local.rules
    content {
      action {
        type = rule.value.action
      }

      priority = rule.key + length(var.custom_rules)
      rule_id  = rule.value.rule_id
      type     = "REGULAR"
    }
  }

  dynamic "rule" {
    for_each = var.custom_rules
    content {
      action {
        type = rule.value.action
      }

      priority = rule.key
      rule_id  = rule.value.rule_id
      type     = "REGULAR"
    }
  }
}

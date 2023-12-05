# DO NOT USE THIS REPO - MIGRATED TO GITLAB

# terraform-aws-waf

A Terraform module to create an AWS Classic Regional WAF with consistent features

## Usage
In its simplest form, this module will create a WAF with all default rules enabled
and a Kinesis Firehose delivery stream to write logs to S3 and CloudWatch.

```$hcl
module waf {
  source = "dwp/waf/aws"

  name                  = "example"
  s3_log_bucket         = "example-bucket"
  whitelist_cidr_blocks = ["0.0.0.0/0"]

  tags = []
}
```

All IPs not included in `whitelist_cidr_blocks` will be blocked by the WAF.

The geo-match rule defaults to Country: GB, and can be overridden/extended using the
`geo_match_constraints` variable.

This WAF applies size constraints on incoming requests, which can be set with the
`max_size_constraints` variable. The default values are (in bytes):

|   Component  | Max allowed size |
| ------------ | ---------------- |
| Body         | 8192             |
| Cookie       | 4092             |
| Query String | 1024             |
| URI          |  512             |

Individual rules can be disabled with the `enabled_rules` variable, and custom ones can
be specified with `custom_rules`. Custom rules have higher priority than the default ones.

## Complex example

```$hcl
resource "aws_wafregional_rule" "custom_rule" {
  name        = "custom_rule"
  metric_name = "custom_rule"

  predicate {
    data_id = ...
    negated = ...
    type    = ...
  }
}

module waf {
  source = "dwp/waf/aws"

  name                  = "example"
  s3_log_bucket         = "example-bucket"
  whitelist_cidr_blocks = ["0.0.0.0/0"]

  max_size_constraints = {
    body         = 1024
    cookie       = 512
    query_string = 256
    uri          = 512
  }

  enabled_rules = {
    xss               = true
    rfi_lfi_traversal = true
    enforce_csrf      = false
    sqli              = false
    ssi               = true
    bad_auth_tokens   = true
  }

  custom_rules = [
    {
        action  = "BLOCK"
        rule_id = aws_wafregional_rule.custom_rule.id
    }
  ]

  tags = []
}
```

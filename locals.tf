locals {
  waf_name = replace(var.name, "-", "")

  enabled_rules = [
    {
      action  = "BLOCK"
      rule_id = aws_wafregional_rule.geo_match.id
    },
    {
      action  = "BLOCK"
      rule_id = aws_wafregional_rule.restrict_sizes.id
    },
    {
      action = "ALLOW"
      rule_id = aws_wafregional_rule.match_ipset.id
    },
    var.enabled_rules.xss ? {
      action  = "BLOCK"
      rule_id = aws_wafregional_rule.mitigate_xss[0].id
    } : null,
    var.enabled_rules.enforce_csrf ? {
      rule_id = aws_wafregional_rule.enforce_csrf[0].id
      action  = "BLOCK"
    } : null,
    var.enabled_rules.rfi_lfi_traversal ? {
      rule_id = aws_wafregional_rule.detect_rfi_lfi_traversal[0].id
      action  = "BLOCK"
    } : null,
    var.enabled_rules.sqli ? {
      rule_id = aws_wafregional_rule.mitigate_sqli[0].id
      action  = "BLOCK"
    } : null,
    var.enabled_rules.ssi ? {
      rule_id = aws_wafregional_rule.detect_ssi[0].id
      action  = "BLOCK"
    } : null,
    var.enabled_rules.bad_auth_tokens ? {
      rule_id = aws_wafregional_rule.detect_bad_auth_tokens[0].id
      action  = "BLOCK"
    } : null
  ]

  rules = [
    for rule in local.enabled_rules :
    rule if rule != null
  ]
}

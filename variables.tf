variable "name" {
  description = "common name"
  type        = string
}

variable "whitelist_cidr_blocks" {
  description = "List of CIDR blocks to be allowed through the WAF"
  type        = list(string)
}

variable "s3_log_bucket" {
  description = "S3 Bucket to use for WAF logs"
  type        = string
}

variable "s3_log_prefix" {
  description = "Prefix to use for S3 WAF logs"
  type        = string
  default     = "waf"
}

variable "default_action" {
  description = "The default action for this WAF. Allowed values are ALLOW, BLOCK and COUNT."
  type        = string
  default     = "BLOCK"
}

variable "geo_match_constraints" {
  description = "Geo match conditions to ALLOW through the WAF"
  type = list(object({
    type  = string
    value = string
  }))
  default = [{
    type  = "Country"
    value = "GB"
  }]
}

variable "max_size_constraints" {
  description = "Constraints to apply on request size on a per component basis in bytes."
  type = object({
    body         = number
    cookie       = number
    query_string = number
    uri          = number
  })
  default = {
    body         = 8192
    cookie       = 4092
    query_string = 1024
    uri          = 512
  }
}

variable "enabled_rules" {
  description = "Specify which default rules are enabled. By default all rules are enabled."
  type = object({
    xss               = bool
    rfi_lfi_traversal = bool
    enforce_csrf      = bool
    sqli              = bool
    ssi               = bool
    bad_auth_tokens   = bool
  })
  default = {
    xss               = true
    rfi_lfi_traversal = true
    enforce_csrf      = true
    sqli              = true
    ssi               = true
    bad_auth_tokens   = true
  }
}

variable "custom_rules" {
  description = "Specify additional rules to be added to the WAF"
  type = list(object({
    rule_id = string
    action  = string
  }))
  default = []
}


variable "tags" {
  description = "tags to apply to aws resource"
  type        = map(string)
}

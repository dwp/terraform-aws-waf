resource "aws_wafregional_geo_match_set" "geo_match" {
  name = "geo_match_set"

  dynamic "geo_match_constraint" {
    for_each = var.geo_match_constraints
    content {
      type  = geo_match_constraint.value.type
      value = geo_match_constraint.value.value
    }
  }
}

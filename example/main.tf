provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.test_account}:role/${var.assume_role}"
  }
}

resource "random_id" "s3_bucket_id" {
  byte_length = 16
}

variable "assume_role" {
  type        = string
  default     = "ci"
  description = "Role to assume"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "${random_id.s3_bucket_id.hex}-waf-test"
}

resource "aws_s3_bucket_acl" "test_bucket_acl" {
  acl    = "private"
  bucket = aws_s3_bucket.test_bucket.id
}

module "waf" {
  source = "../"

  name = "waf-module-test"

  whitelist_cidr_blocks = ["10.100.0.0/24"]
  s3_log_bucket         = resource.aws_s3_bucket.test_bucket.arn

  tags = {
    Name : "waf-module-test"
  }
}

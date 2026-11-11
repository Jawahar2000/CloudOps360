
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "cloudops360"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "cloudops_storage" {
  bucket = "cloudops360-jawahar-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "CloudOps360-Storage"
    Environment = "Learning"
    Project     = "CloudOps360"
  }
}

resource "aws_s3_bucket_versioning" "cloudops_versioning" {
  bucket = aws_s3_bucket.cloudops_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudops_encryption" {
  bucket = aws_s3_bucket.cloudops_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudops_private" {
  bucket = aws_s3_bucket.cloudops_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

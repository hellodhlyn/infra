variable "bucket_name" {
  type      = string
  sensitive = true
}

resource "aws_s3_bucket" "assets-bucket" {
  bucket = var.bucket_name

  tags = {
    Service = "wolzip"
  }
}

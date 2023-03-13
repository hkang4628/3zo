# S3 설정 부분
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "flower53-image-bucket"
  
  tags = {
    Name = "Image bucket"
  }

  # Buckets cannot be deleted until they are empty. By default, Terraform will
  # delete buckets before deleting their contents, but this behaviour can be
  # changed with the `force_destroy` parameter.
  force_destroy = true
}



resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_object" "origin_folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "origin/"

  content_type = "text/plain"
  content      = "This is the Origin directory"
}

resource "aws_s3_bucket_object" "thumbnail_folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "thumbnail/"

  content_type = "text/plain"
  content      = "This is the Thumbnail directory"
}

resource "aws_s3_bucket_object" "resized_folder" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = "resized/"

  content_type = "text/plain"
  content      = "This is the Resized directory"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  topic {
    id            = "s3_upload_notification"
    # topic_arn     = aws_sns_topic.s3_event_topic.arn
    topic_arn     = "arn:aws:sns:us-east-1:881855020500:s3_event_topic"
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "origin/"
    # filter_suffix = ".jpg"
  }
}
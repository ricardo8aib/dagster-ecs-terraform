# Define the S3 bucket
resource "aws_s3_bucket" "code_location" {
  bucket        = var.BUCKET_NAME
  force_destroy = true
}

# Enable EventBridge Notifications
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket      = aws_s3_bucket.code_location.id
  eventbridge = true
}


# Enable versioning
resource "aws_s3_bucket_versioning" "code_location_versioning" {
  bucket = aws_s3_bucket.code_location.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "bucket_notification_policy" {
  bucket = aws_s3_bucket.code_location.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "s3.amazonaws.com"
    },
    "Action": "s3:PutBucketNotification",
    "Resource": "${aws_s3_bucket.code_location.arn}"
  }]
}
EOF
}



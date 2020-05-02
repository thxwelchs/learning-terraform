resource "aws_s3_bucket" "this" {
  bucket = "thxwelchs-artifacts"
  acl = "private"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.this.bucket
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          AWS: "arn:aws:iam::600734575887:root"
        },
        Action: "s3:PutObject",
        Resource: "arn:aws:s3:::${aws_s3_bucket.this.bucket}/logs/*"
      },
      {
        Effect: "Allow",
        Principal: {
          Service: "delivery.logs.amazonaws.com"
        },
        Action: "s3:PutObject",
        Resource: "arn:aws:s3:::${aws_s3_bucket.this.bucket}/logs/*"
        Condition: {
          StringEquals: {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      },
      {
        Effect: "Allow",
        Principal: {
          Service: "delivery.logs.amazonaws.com"
        },
        Action: "s3:GetBucketAcl",
        Resource: "arn:aws:s3:::${aws_s3_bucket.this.bucket}"
      }
    ]
  })
}
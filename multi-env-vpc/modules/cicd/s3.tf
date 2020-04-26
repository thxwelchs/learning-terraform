resource "aws_s3_bucket" "this" {
  bucket = "thxwelchs-artifacts"
  acl = "private"
}

//resource "aws_s3_bucket_policy" "this" {
//  bucket = aws_s3_bucket.this.id
//  policy = jsonencode({
//    Id: "Policy1513880777555",
//    Version: "2012-10-17",
//    Statement: [
//      {
//        Sid: "Stmt1513880773845",
//        Action: "s3:*",
//        Effect: "Allow",
//        Resource: [
//          aws_s3_bucket.this.arn,
//          "${aws_s3_bucket.this.arn}/*",
//        ],
//        Principal: {
//          "AWS": [
//            "arn:aws:iam::${aws_iam_role.codebuild_role.arn}"
//          ]
//        }
//      }
//    ]
//  })
//}
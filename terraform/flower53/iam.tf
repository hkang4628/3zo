# IAM 역할 생성
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM 정책 연결
resource "aws_iam_policy_attachment" "lambda_default_policy_attachment" {
  name       = "lambda-default-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_role.name]
}


# S3 접근 권한을 위한 IAM 정책 생성
resource "aws_iam_policy" "s3_policy" {
  name = "s3_policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
      }
    ]
  })
}


# S3 접근 권한을 위한 IAM 정책 연결
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.lambda_role.name
}


# SQS ReceiveMessage API 접근 권한을 위한 IAM 정책 생성
resource "aws_iam_policy" "sqs_policy" {
  name        = "sqs_policy"
  description = "Allows Lambda function to receive messages from SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sqs:*"] # 모든 권한 
        # Action   = [
        #   "sqs:GetQueueUrl",
        #   "sqs:ReceiveMessage",
        #   "sqs:DeleteMessage"
        # ]
        # Resource  = aws_sqs_queue.thumbnail_queue.arn
        Resource = "arn:aws:sqs:*:*:*" # 모든 sqs의 권한 부여
      }
    ]
  })
}



# SNS ReceiveMessage API 접근 권한을 위한 IAM 정책 생성
resource "aws_iam_policy" "sns_policy" {
  name        = "sns_policy"
  description = "Allows Lambda function to receive messages from SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sns:*"] # 모든 권한 
        Resource = "arn:aws:sns:*:*:*" # 모든 sns의 권한 부여
      }
    ]
  })
}

# SNS 접근 권한을 위한 IAM 정책 연결
resource "aws_iam_policy_attachment" "lambda_sns_policy_attachment" {
  name       = "lambda_sns_policy_attachment"
  policy_arn = aws_iam_policy.sns_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}


# SQS 접근 권한을 위한 IAM 정책 연결
resource "aws_iam_policy_attachment" "lambda_sqs_policy_attachment" {
  name       = "lambda_sqs_policy_attachment"
  policy_arn = aws_iam_policy.sqs_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}


# SES ReceiveMessage API 접근 권한을 위한 IAM 정책 생성
resource "aws_iam_policy" "ses_policy" {
  name        = "ses_policy"
  description = "Allows Lambda function to receive messages from SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ses:*"] # 모든 권한 
        Resource = "arn:aws:ses:*:*:*" # 모든 ses의 권한 부여
      }
    ]
  })
}


# SES 접근 권한을 위한 IAM 정책 연결
resource "aws_iam_policy_attachment" "lambda_ses_policy_attachment" {
  name       = "lambda_ses_policy_attachment"
  policy_arn = aws_iam_policy.ses_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}
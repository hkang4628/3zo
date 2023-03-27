# Resizing Lambda 함수 생성
resource "aws_lambda_function" "resizing_lambda" {
  description      = "Create a resized image"
  filename         = "lambda_src/CreateResizedImage.zip"
  function_name    = "resizing_img"
  role             = aws_iam_role.lambda_role.arn
  handler          = "CreateResizedImage.handler"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("lambda_src/CreateResizedImage.zip")

  # 람다 함수에 대한 메모리와 시간 제한 설정
  memory_size = 128
  timeout     = 3

# Lambda에서 사용할 환경변수 설정
 environment {
    variables = {
      S3_BUCKET_NAME   = aws_s3_bucket.s3_bucket.bucket
      RESIZED_BUCKET_NAME = aws_s3_bucket.s3_bucket.bucket
      SQS_QUEUE_NAME = aws_sqs_queue.resizing_queue.name
    }
  }
}

# Trigger mapping
resource "aws_lambda_event_source_mapping" "resizing_event_source_mapping" {
  batch_size                         = "1"
  bisect_batch_on_function_error     = "false"
  enabled                            = "true"
  event_source_arn                   = aws_sqs_queue.resizing_queue.arn
  function_name                      = aws_lambda_function.resizing_lambda.arn
}



# Thumbnail Lambda 함수 생성
resource "aws_lambda_function" "thumbnail_lambda" {
  description      = "Create a thumbnail image"
  filename         = "lambda_src/CreateThumbnailImage.zip"
  function_name    = "thumbnail_img"
  role             = aws_iam_role.lambda_role.arn
  handler          = "CreateThumbnailImage.handler"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("lambda_src/CreateThumbnailImage.zip")

  # 람다 함수에 대한 메모리와 시간 제한 설정
  memory_size = 128
  timeout     = 3

# Lambda에서 사용할 환경변수 설정
 environment {
    variables = {
      S3_BUCKET_NAME   = aws_s3_bucket.s3_bucket.bucket
      THUMBNAIL_BUCKET_NAME = aws_s3_bucket.s3_bucket.bucket
      SQS_QUEUE_NAME = aws_sqs_queue.thumbnail_queue.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "thumbnail_event_source_mapping" {
  batch_size                         = "1"
  bisect_batch_on_function_error     = "false"
  enabled                            = "true"
  event_source_arn                   = aws_sqs_queue.thumbnail_queue.arn
  function_name                      = aws_lambda_function.thumbnail_lambda.arn
}



# ses Lambda 함수 생성
resource "aws_lambda_function" "ses_lambda" {
  description      = "use SES to send mail"
  filename         = "lambda_src/SendMail.zip"
  function_name    = "ses_mail"
  role             = aws_iam_role.lambda_role.arn
  handler          = "SendMail.handler"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("lambda_src/SendMail.zip")

  # 람다 함수에 대한 메모리와 시간 제한 설정
  memory_size = 128
  timeout     = 3

}

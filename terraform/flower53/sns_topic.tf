resource "aws_sns_topic" "s3_event_topic" {
  display_name = "s3_event_topic"
  fifo_topic   = "false"
  name         = "s3_event_topic"
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = aws_sns_topic.s3_event_topic.arn

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "default-id",
      "Statement" : [
        {
          "Sid" : "default-statement-id",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "*"
          },
          "Action" : "SNS:Publish",
          "Resource" : "arn:aws:sns:us-west-2:881855020500:s3_event_topic",
          "Condition" : {
            "ArnLike" : {
              "aws:SourceArn" : "arn:aws:s3:::flower53-image-bucket"
            }
          }
        }
      ]
  })
}


resource "aws_sns_topic_subscription" "thumbnail_queue_subscription" {
  topic_arn = aws_sns_topic.s3_event_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.thumbnail_queue.arn
}

resource "aws_sns_topic_subscription" "resizing_queue_subscription" {
  topic_arn = aws_sns_topic.s3_event_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.resizing_queue.arn
}
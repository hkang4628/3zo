resource "aws_sns_topic" "s3_event_topic" {
  display_name                             = "s3_event_topic"
  fifo_topic                               = "false"
  name                                     = "s3_event_topic"
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
arn   =   aws_sns_topic.s3_event_topic.arn

policy = jsonencode(
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "881855020500"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_sns_topic.s3_event_topic.arn}",
      "Sid": "__default_statement_ID"
    }
  ],
  "Version": "2008-10-17"
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
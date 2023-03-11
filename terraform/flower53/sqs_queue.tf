resource "aws_sqs_queue" "thumbnail_queue" {
  name                              = "thumbnail_queue"
  fifo_queue                        = "false"

}
resource "aws_sqs_queue_policy" "thumbnail_queue_policy" {
  queue_url = aws_sqs_queue.thumbnail_queue.id
  policy = jsonencode(
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": "SQS:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::881855020500:root"
      },
      "Resource": "arn:aws:sqs:us-west-2:881855020500:thumbnail_queue",
      "Sid": "__owner_statement"
    },
    {
      "Action": "SQS:SendMessage",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "${aws_sns_topic.s3_event_topic.arn}"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource":  "arn:aws:sqs:us-west-2:881855020500:thumbnail_queue",
      "Sid": "topic-subscription-arn:${aws_sns_topic.s3_event_topic.arn}"
    }
  ],
  "Version": "2008-10-17"
})

}


resource "aws_sqs_queue" "resizing_queue" {
  name                              = "resizing_queue"
  fifo_queue                        = "false"
}

resource "aws_sqs_queue_policy" "resizing_queue_policy" {
  queue_url = aws_sqs_queue.resizing_queue.id
  policy = jsonencode(
{
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Action": "SQS:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::881855020500:root"
      },
      "Resource": "arn:aws:sqs:us-west-2:881855020500:resizing_queue",
      "Sid": "__owner_statement"
    },
    {
      "Action": "SQS:SendMessage",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "${aws_sns_topic.s3_event_topic.arn}"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource":  "arn:aws:sqs:us-west-2:881855020500:resizing_queue",
      "Sid": "topic-subscription-arn:${aws_sns_topic.s3_event_topic.arn}"
    }
  ],
  "Version": "2008-10-17"
})

}
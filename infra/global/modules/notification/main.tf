/* CloudWatchEventの作成 */
resource "aws_cloudwatch_event_rule" "securityhub" {
  name        = "${var.prefix}-securityhub"
  description = "SecurutiHub High and Critical Events Event"

  event_pattern = <<EOF
{
  "source": [
    "aws.securityhub"
  ],
  "detail-type": [
    "Security Hub Findings - Imported"
  ],
  "detail": {
    "findings":
      {
        "Compliance": {
          "Status": [
            {
              "anything-but": "PASSED"
            }
          ]
        },
        "Severity": {
           "Label": [
             "CRITICAL",
             "HIGH"
           ]
        },
        "Workflow": {
          "Status": [
            "NEW"
          ]
        },
        "RecordState": [
          "ACTIVE"
        ]
      }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns-publish" {
  rule      = aws_cloudwatch_event_rule.securityhub.name
  target_id = aws_sns_topic.chatbot.name
  arn       = aws_sns_topic.chatbot.arn
}


/* SNS Topicの作成 */

# マネジメントコンソールからChatBotを利用する際に指定する
resource "aws_sns_topic" "chatbot" {
  name              = "${var.prefix}-topic"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_policy" "chatbot" {
  arn    = aws_sns_topic.chatbot.arn
  policy = data.aws_iam_policy_document.chatbot.json
}

data "aws_iam_policy_document" "chatbot" {
  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.chatbot.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

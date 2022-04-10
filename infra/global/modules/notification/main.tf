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
  kms_master_key_id = aws_kms_key.for_encrypt_sns_topic.id
}

resource "aws_sns_topic_policy" "chatbot" {
  arn    = aws_sns_topic.chatbot.arn
  policy = data.aws_iam_policy_document.chatbot.json
}

data "aws_iam_policy_document" "chatbot" {
  statement {
    sid       = "Allow CloudwatchEvents Publish"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.chatbot.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "for_encrypt_sns_topic" {
  description         = "guarddutyからのeventを受けるsns topic暗号化用"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.policy_for_encrypt_sns_topic.json
}


resource "aws_kms_alias" "for_encrypt_sns_topic_alias" {
  name          = "alias/guardduty/for_encrypt_sns_topic"
  target_key_id = aws_kms_key.for_encrypt_sns_topic.key_id
}

data "aws_iam_policy_document" "policy_for_encrypt_sns_topic" {
  version = "2012-10-17"

  # defaultでついてくるルートアカウントに対する権限設定
  statement {
    sid    = "Enable Root User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*",
    ]
  }

  # events.amazonaws.com に対する権限が暗号化対象のサービス操作に必要
  statement {
    sid    = "AWSEvents"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  }
}

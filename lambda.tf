data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "NetworkFirewallNotification-Role" {
  name               = "${var.project}-NetworkFirewallNotification-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json
  inline_policy {
    name = "${var.project}-NetworkFirewallNotificationLambda-CloudWatch"
    policy = jsonencode({
        Version: "2012-10-17",
        Statement: [
            {
                Effect: "Allow",
                Action: "logs:CreateLogGroup",
                Resource: "arn:aws:logs:${var.region}:${var.account_id}:*"
            },
            {
                Effect: "Allow",
                Action: [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource: "${aws_cloudwatch_log_group.networkfirewall_notification_cw_lambda_loggroup.arn}:*"
            }
        ]
    })
  }
  inline_policy {
    name = "${var.project}-ParseHtmlMail-SES"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
            Effect: "Allow",
            Action: [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            Resource: "*"
        }
      ]
    })
  }
}

resource "aws_lambda_function" "NetworkFirewallNotification" {
  filename      = "lambdas-code/NetworkFirewallNotification.zip"
  function_name = "${var.project}-NetworkFirewallNotification"
  role          = aws_iam_role.NetworkFirewallNotification-Role.arn
  handler       = "NetworkFirewallNotification.lambda_handler"
  source_code_hash = filebase64sha256("lambdas-code/NetworkFirewallNotification.zip")
  runtime = "python3.9"
  environment {
    variables = {
      ses_emails_recipients = local.ses_emails_list
      ses_emails_sender = var.ses_emails_sender
      account_id = var.account_id
      region = var.region
    }
  }
}

resource "aws_lambda_permission" "allow_lambda_execution_from_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.NetworkFirewallNotification.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  # source_arn    = aws_cloudwatch_log_group.networkfirewall_notification_cw_loggroup.arn
  source_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/network-firewall:*"
  source_account = var.account_id
}

resource "aws_cloudwatch_log_group" "networkfirewall_notification_cw_lambda_loggroup" {
  name = "/aws/lambda/${var.project}-NetworkFirewallNotification"
}
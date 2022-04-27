resource "aws_cloudwatch_log_subscription_filter" "lambdafunction_logfilter" {
  name            = "NetworkFirewall_Blocked_Requests"
  log_group_name  = var.nf_loggroup
  filter_pattern  = "blocked"
  destination_arn = aws_lambda_function.NetworkFirewallNotification.arn
  distribution    = "Random"
}
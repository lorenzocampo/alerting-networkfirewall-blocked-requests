# resource "aws_cloudwatch_log_group" "networkfirewall_notification_cw_loggroup" {
#   name = "/aws/networkfirewall/${var.project}/${var.region}"
# }

resource "aws_cloudwatch_log_subscription_filter" "lambdafunction_logfilter" {
  name            = "NetworkFirewall_Blocked_Requests"
  # log_group_name  = aws_cloudwatch_log_group.networkfirewall_notification_cw_loggroup.name
  log_group_name = "/aws/network-firewall"
  filter_pattern  = "blocked"
  destination_arn = aws_lambda_function.NetworkFirewallNotification.arn
  distribution    = "Random"
}
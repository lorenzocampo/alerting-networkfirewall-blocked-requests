locals {
  ses_emails_list = jsonencode(var.ses_emails_recipients)
}
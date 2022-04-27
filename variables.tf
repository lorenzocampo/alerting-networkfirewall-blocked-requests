variable "region" {
  type        = string
  description = "region where the resources will be created"
}

variable "project" {
  type        = string
  description = "project code to be used for resources naming"
}

variable "account_id" {
  type        = string
  description = "account id where the resources will be deployed"
}

variable "ses_emails_sender" {
  type = string
  description = "email address to send finding emails"
}

variable "ses_emails_recipients" {
  type = map
  description = "list of emails to receive notification emails"
}

variable "nf_loggroup" {
  type = string
  description = "your network firewall log group name"
}
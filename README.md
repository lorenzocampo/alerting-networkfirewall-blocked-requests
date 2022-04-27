# Alerting AWS Network Firewall Blocked Requests

Terraform code that creates a solution for sending emails when a blocked request is logged in Network Firewall. It implements the following resources:

* **[Cloudwatch Log Group]** --> Two Cloudwatch LogGroups. One for Lambda function logs and the other for Network Firewall logs.
* **[Cloudwatch Subscription Filter]** --> A Cloudwatch LogGroup Subscription Filter with AWS Lambda.
* **[Lambda Function]** --> A Lambda function to receive the LogGroup strem (encoded) and send an HTML mail with the blocked request information.
* **[IAM Role]** --> Role assumed by the Lambda Function with permissions in Cloudwatch Logs and SES.
* **[SES Identity]** --> Verified identities for sending and receiving the findings emails.

[Cloudwatch Log Group]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html
[Cloudwatch Subscription Filter]:    https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#LambdaFunctionExample
[Lambda Function]: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
[IAM Role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[SES Identity]: https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html


## High Level Architecture

![HLA](https://github.com/lorenzocampo/alerting-networkfirewall-blocked-requests/blob/main/images/NetworkFirewallAlerts.JPG)

## How It Works

1. A Cloudwatch LogGroup is logging AWS Network Firewall logs.

2. The Lambda Subscription Filter searchs for the word 'blocked' and when it detects it, sends a data strem (encoded) containing the data event to the Lambda Function.

3. The Lambda Function decodes the event and extract the blocked request information. Then it formats the body in HTML and send a mail with all the information.


## Usage

1. Clone the repository

    ```
    $ git clone https://github.com/lorenzocampo/alerting-networkfirewall-blocked-requests.git
    ```

2. Initialize a working directory containing Terraform configuration files:

    ```
    $ terraform init
    ```

3. Create an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure

    ```
    $ terraform plan
    ```

4. Executes the actions proposed in a Terraform plan

    ```
    $ terraform apply
    ```
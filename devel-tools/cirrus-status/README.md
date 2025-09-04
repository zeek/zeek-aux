# Cirrus Status Slackbot

See https://docs.aws.amazon.com/lambda/latest/dg/python-package.html for how to deploy
this to AWS. You'll need to upload a zip file containing the dependency modules from
requirements.txt.

You'll also need to make sure that a few environment variables are set in the lambda
environment:

- GRAPHQL_ENDPOINT: The full URL of the graphql API being queried
- GRAPHQL_TOKEN: The API token for talking to the graphql API
- SLACK_WEBHOOK_URL: The full URL of a webhook for Slack to send data to
- BALANCE_LIMIT: The upper limit of the available Cirrus credits per month

### Reporting

The bot will report a daily message containing the total amount of credits used for the
current month. It will also report two conditional messages:

- A warning if the number of used credits is trending towards having used the entire limit
  for the month. It does this by comparing the number of available credits per day against
  the number of credits used so far.
- A louder warning if the credit balance is exhausted before the end of the month.

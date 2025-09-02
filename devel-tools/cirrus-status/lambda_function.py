import calendar
import logging
import os
from datetime import datetime, timezone

import requests
from gql import Client, gql
from gql.transport import exceptions
from gql.transport.aiohttp import AIOHTTPTransport

# Configure logging
logger = logging.getLogger()
logger.setLevel("INFO")


def lambda_handler(event, context):
    # Configuration from environment variables
    GRAPHQL_ENDPOINT = os.getenv("GRAPHQL_ENDPOINT")
    GRAPHQL_TOKEN = os.getenv("GRAPHQL_TOKEN")
    SLACK_WEBHOOK_URL = os.getenv("SLACK_WEBHOOK_URL")
    BALANCE_LIMIT = os.getenv("BALANCE_LIMIT")

    if not GRAPHQL_ENDPOINT:
        logging.error("GRAPHQL_ENDPOINT environment variable is missing")
        return
    if not GRAPHQL_TOKEN:
        logging.error("GRAPHQL_TOKEN environment variable is missing")
        return
    if not SLACK_WEBHOOK_URL:
        logging.error("SLACK_WEBHOOK_URL environment variable is missing")
        return
    if not BALANCE_LIMIT:
        logging.error("BALANCE_LIMIT environment variable is missing")
        return

    try:
        BALANCE_LIMIT = float(BALANCE_LIMIT)
    except ValueError:
        logging.error(
            "BALANCE_LIMIT environment variable must be a floating-point number"
        )
        return

    graphql_headers = {"Authorization": f"Bearer {GRAPHQL_TOKEN}"}
    gql_transport = AIOHTTPTransport(url=GRAPHQL_ENDPOINT, headers=graphql_headers)
    gql_client = Client(transport=gql_transport)

    query = gql(
        """
        query GetCreditBalance {
        ownerInfoByName(platform: "github", name: "zeek") {
            balanceInCredits
        }
        }
        """
    )

    message = ""

    try:
        result = gql_client.execute(query)
    except exceptions.TransportQueryError as tqe:
        message = "Query error while requesting GraphQL data. See AWS Lambda logs for more details."
        logging.error(f"Query error while requesting GraphQL data: {tqe}")
    except exceptions.TransportProtocolError as tpe:
        message = "Protocol error while requesting GraphQL data. See AWS Lambda logs for more details."
        logging.error(f"Protocol error while requesting GraphQL data: {tpe}")
    except exceptions.TransportServerError as tse:
        message = "Server error while requesting GraphQL data. See AWS Lambda logs for more details."
        logging.error(f"Server error while requesting GraphQL data: {tse}")
    else:
        # We get 2500 credits monthly. It starts with 0 available and counts down to
        # -2500 as we use them. When we break that point, we need to by more.
        balance = result.get("ownerInfoByName", {}).get("balanceInCredits", None)
        if balance:
            balance = float(balance) * -1.0
            today = datetime.now(tz=timezone.utc).date()
            message = (
                f"Cirrus credits used as of {today} (UTC): {balance} of {BALANCE_LIMIT}"
            )
            if balance > BALANCE_LIMIT:
                message += f"\n@here ❌❌ WARNING: We're currently over our limit by {balance - BALANCE_LIMIT} credits!"
            elif today.day > 15:
                # After the 15th day of the month, start checking to see if we're
                # trending towards running out of credits. This lets us catch it
                # early.
                [_, monthdays] = calendar.monthrange(today.year, today.month)
                allowed_credits_per_day = BALANCE_LIMIT / monthdays
                used_credits_per_day = balance / today.day
                max_usage = round(today.day * allowed_credits_per_day * 1.2, 2)
                trending_balance = used_credits_per_day * monthdays
                if balance > max_usage:
                    message += f"\n@here ⚠️⚠️ We're trending to be over our limit by {trending_balance - BALANCE_LIMIT} credits!"

    slack_payload = {"text": message}
    slack_headers = {"Content-type": "application/json"}

    try:
        slack_response = requests.post(
            SLACK_WEBHOOK_URL, json=slack_payload, timeout=30, headers=slack_headers
        )
        slack_response.raise_for_status()
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to post to Slack webhook: {e}")

import os
import boto3
from botocore.exceptions import ClientError

AWS_REGION = os.getenv("AWS_REGION", "ap-south-1")

sns_client = boto3.client(
    "sns",
    region_name=AWS_REGION
)


def send_notification(topic_arn, subject, message):
    try:
        sns_client.publish(
            TopicArn=topic_arn,
            Subject=subject,
            Message=message
        )

        print("✅ SNS notification sent successfully.")

    except ClientError as e:
        print("❌ Failed to send SNS notification")
        print(e)
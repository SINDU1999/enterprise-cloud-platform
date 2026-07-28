import os
import boto3
from botocore.exceptions import ClientError


s3_client = boto3.client("s3")


def upload_to_s3(file_path, bucket_name, s3_key):

    try:

        s3_client.upload_file(
            Filename=file_path,
            Bucket=bucket_name,
            Key=s3_key
        )

        print(f"✅ Uploaded: {file_path}")

        return True

    except ClientError as e:

        print(f"❌ Failed to upload {file_path}")
        print(e)

        return False
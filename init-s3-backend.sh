#!/bin/zsh -x

REGION="us-east-1"
BUCKET="terragrunt-localstack-${REGION}"

aws s3api create-bucket \
  --profile localstack \
  --bucket ${BUCKET} \
  --region ${REGION}

aws s3api put-bucket-versioning \
  --profile localstack \
  --bucket ${BUCKET} \
  --region ${REGION} \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --profile localstack \
  --bucket ${BUCKET} \
  --region ${REGION} \
  --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

aws s3api put-bucket-policy \
  --profile localstack \
	--bucket ${BUCKET} \
	--region ${REGION} \
	--policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::000000000000:root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::'${BUCKET}'"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::000000000000:root"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::'${BUCKET}'/*"
        }
    ]
}'

#!/bin/bash

echo "========================================"
echo " Amazon ECR Image Details"
echo "========================================"

REPOSITORY="enterprise-cloud-platform"

aws ecr describe-images \
    --repository-name "$REPOSITORY" \
    --query 'imageDetails[*].[imageTags[0],imageSizeInBytes,imagePushedAt]' \
    --output table

echo ""
echo "========================================"
echo "ECR Image Details Retrieved Successfully"
echo "========================================"
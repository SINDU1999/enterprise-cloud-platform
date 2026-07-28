#!/bin/bash

echo "========================================"
echo " Amazon ECR Repository Summary"
echo "========================================"

REPOSITORY="enterprise-cloud-platform"

IMAGE_COUNT=$(aws ecr list-images \
    --repository-name "$REPOSITORY" \
    --query 'length(imageIds)' \
    --output text)

TAGGED_COUNT=$(aws ecr list-images \
    --repository-name "$REPOSITORY" \
    --filter tagStatus=TAGGED \
    --query 'length(imageIds)' \
    --output text)

UNTAGGED_COUNT=$(aws ecr list-images \
    --repository-name "$REPOSITORY" \
    --filter tagStatus=UNTAGGED \
    --query 'length(imageIds)' \
    --output text)

echo ""
echo "Repository Name : $REPOSITORY"
echo "Total Images    : $IMAGE_COUNT"
echo "Tagged Images   : $TAGGED_COUNT"
echo "Untagged Images : $UNTAGGED_COUNT"

echo ""
echo "========================================"
echo "Repository Summary Completed"
echo "========================================"
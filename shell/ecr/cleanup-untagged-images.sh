#!/bin/bash

echo "========================================"
echo " Amazon ECR Untagged Image Cleanup"
echo "========================================"

REPOSITORY="enterprise-cloud-platform"

echo ""
echo "Deleting untagged images..."

IMAGE_IDS=$(aws ecr list-images \
    --repository-name "$REPOSITORY" \
    --filter tagStatus=UNTAGGED \
    --query 'imageIds[*]' \
    --output json)

if [ "$IMAGE_IDS" = "[]" ]; then
    echo "No untagged images found."
else
    aws ecr batch-delete-image \
        --repository-name "$REPOSITORY" \
        --image-ids "$IMAGE_IDS"
fi

echo ""
echo "========================================"
echo "Untagged Image Cleanup Completed"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Amazon ECR Images"
echo "========================================"

REPOSITORY="enterprise-cloud-platform"

echo ""
printf "%-15s %-25s\n" "Image Tag" "Image Digest"
echo "--------------------------------------------------------------"

aws ecr describe-images \
    --repository-name "$REPOSITORY" \
    --query 'imageDetails[*].[join(`,`, imageTags),imageDigest]' \
    --output text | while read tag digest
do
    printf "%-15s %-25s\n" "$tag" "$digest"
done

echo ""
echo "========================================"
echo "ECR Images Listing Completed"
echo "========================================"
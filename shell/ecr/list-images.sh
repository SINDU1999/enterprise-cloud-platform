#!/bin/bash

echo "========================================"
echo " Amazon ECR Images"
echo "========================================"

REPOSITORY="enterprise-cloud-platform"

echo ""
printf "%-20s %-75s\n" "Image Tag" "Image Digest"
echo "---------------------------------------------------------------------------------------------------------------"

aws ecr describe-images \
    --repository-name "$REPOSITORY" \
    --query 'imageDetails[*].[imageTags[0],imageDigest]' \
    --output text | while read tag digest
do
    if [ "$tag" = "None" ] || [ -z "$tag" ]; then
        tag="UNTAGGED"
    fi

    printf "%-20s %-75s\n" "$tag" "$digest"
done

echo ""
echo "========================================"
echo "ECR Images Listing Completed"
echo "========================================"
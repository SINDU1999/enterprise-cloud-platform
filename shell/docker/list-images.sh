#!/bin/bash

echo "========================================"
echo " Docker Images"
echo "========================================"

printf "%-35s %-20s %-20s %-15s\n" "Repository" "Tag" "Image ID" "Size"

docker images --format "{{.Repository}} {{.Tag}} {{.ID}} {{.Size}}" | while read repository tag imageid size
do
    printf "%-35s %-20s %-20s %-15s\n" \
        "$repository" \
        "$tag" \
        "$imageid" \
        "$size"
done

echo ""
echo "========================================"
echo "Docker Images Listing Completed"
echo "========================================"
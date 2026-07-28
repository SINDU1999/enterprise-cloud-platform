#!/bin/bash

echo "========================================"
echo " Docker Containers"
echo "========================================"

printf "%-15s %-35s %-20s %-20s\n" "Container ID" "Image" "Status" "Name"

docker ps -a --format "{{.ID}} {{.Image}} {{.Status}} {{.Names}}" | while read id image status name
do
    printf "%-15s %-35s %-20s %-20s\n" \
        "$id" \
        "$image" \
        "$status" \
        "$name"
done

echo ""
echo "========================================"
echo "Docker Containers Listing Completed"
echo "========================================"
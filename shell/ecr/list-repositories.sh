#!/bin/bash

echo "========================================"
echo " Amazon ECR Repositories"
echo "========================================"

echo ""
printf "%-40s %-20s\n" "Repository Name" "URI"
echo "--------------------------------------------------------------------------------"

aws ecr describe-repositories \
--query 'repositories[*].[repositoryName,repositoryUri]' \
--output text | while read repository uri
do
    printf "%-40s %-20s\n" "$repository" "$uri"
done

echo ""
echo "========================================"
echo "ECR Repository Listing Completed"
echo "========================================"
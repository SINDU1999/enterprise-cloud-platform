#!/bin/bash

echo "========================================"
echo " Docker Image Cleanup"
echo "========================================"

echo ""
echo "Removing dangling Docker images..."

docker image prune -f

echo ""
echo "Current Docker Images:"
docker images

echo ""
echo "========================================"
echo "Docker Image Cleanup Completed"
echo "========================================"
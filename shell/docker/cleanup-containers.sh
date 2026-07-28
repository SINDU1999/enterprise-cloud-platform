#!/bin/bash

echo "========================================"
echo " Docker Container Cleanup"
echo "========================================"

echo ""
echo "Removing stopped containers..."

docker container prune -f

echo ""
echo "Current Containers:"
docker ps -a

echo ""
echo "========================================"
echo "Docker Container Cleanup Completed"
echo "========================================"
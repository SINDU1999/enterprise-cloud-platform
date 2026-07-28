#!/bin/bash

echo "========================================"
echo " Docker Information"
echo "========================================"

echo ""
echo "Docker Version:"
docker --version

echo ""
echo "Docker Server Information:"
docker info

echo ""
echo "Docker Service Status:"
systemctl status docker --no-pager

echo ""
echo "========================================"
echo "Docker Information Check Completed"
echo "========================================"
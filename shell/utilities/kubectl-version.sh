#!/bin/bash

echo "========================================"
echo " Kubernetes Version Information"
echo "========================================"

echo ""
echo "Kubectl Client Version"
echo "----------------------------------------"
kubectl version --client

echo ""
echo "Kubernetes Server Version"
echo "----------------------------------------"
kubectl version

echo ""
echo "API Resources"
echo "----------------------------------------"
kubectl api-resources | head -20

echo ""
echo "========================================"
echo "Version Information Retrieved Successfully"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Kubernetes Cluster Version Information"
echo "========================================"

echo ""
echo "Current Context:"
kubectl config current-context

echo ""
echo "Cluster Information:"
kubectl cluster-info

echo ""
echo "Kubernetes Client and Server Version:"
kubectl version

echo ""
echo "========================================"
echo "Cluster Version Check Completed"
echo "========================================"
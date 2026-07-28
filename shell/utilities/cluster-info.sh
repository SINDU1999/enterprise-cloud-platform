#!/bin/bash

echo "========================================"
echo " Kubernetes Cluster Information"
echo "========================================"

echo ""
echo "Cluster Information"
echo "----------------------------------------"
kubectl cluster-info

echo ""
echo "Cluster Nodes"
echo "----------------------------------------"
kubectl get nodes -o wide

echo ""
echo "Namespaces"
echo "----------------------------------------"
kubectl get namespaces

echo ""
echo "========================================"
echo "Cluster Information Retrieved Successfully"
echo "========================================"
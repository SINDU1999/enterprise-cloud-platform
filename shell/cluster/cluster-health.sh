#!/bin/bash

echo "========================================"
echo " Enterprise Cluster Health Check"
echo "========================================"

echo ""
echo "Current Context:"
kubectl config current-context

echo ""
echo "Cluster Info:"
kubectl cluster-info

echo ""
echo "Nodes:"
kubectl get nodes

echo ""
echo "Namespaces:"
kubectl get ns

echo ""
echo "Pods:"
kubectl get pods -A

echo ""
echo "Deployments:"
kubectl get deployments -A

echo ""
echo "Services:"
kubectl get svc -A

echo ""
echo "Persistent Volume Claims:"
kubectl get pvc -A

echo ""
echo "========================================"
echo "Health Check Completed"
echo "========================================"
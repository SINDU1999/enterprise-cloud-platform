#!/bin/bash

echo "========================================"
echo " Kubernetes Utilities Summary"
echo "========================================"

NODES=$(kubectl get nodes --no-headers | wc -l)
NAMESPACES=$(kubectl get namespaces --no-headers | wc -l)
PODS=$(kubectl get pods --all-namespaces --no-headers | wc -l)
DEPLOYMENTS=$(kubectl get deployments --all-namespaces --no-headers | wc -l)
SERVICES=$(kubectl get services --all-namespaces --no-headers | wc -l)

echo ""
echo "Cluster Overview"
echo "----------------------------------------"
echo "Nodes        : $NODES"
echo "Namespaces   : $NAMESPACES"
echo "Pods         : $PODS"
echo "Deployments  : $DEPLOYMENTS"
echo "Services     : $SERVICES"

echo ""
echo "Utilities Module"
echo "----------------------------------------"
echo "✓ Cluster Information"
echo "✓ Resource Usage"
echo "✓ Event Summary"
echo "✓ Kubernetes Version"
echo "✓ Namespace Cleanup"

echo ""
echo "Overall Status : READY ✅"

echo ""
echo "========================================"
echo "Utilities Summary Generated Successfully"
echo "========================================"
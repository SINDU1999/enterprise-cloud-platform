#!/bin/bash

echo "========================================"
echo " Kubernetes Resource Usage"
echo "========================================"

echo ""
echo "Node Resource Usage"
echo "----------------------------------------"

if kubectl top nodes >/dev/null 2>&1; then
    kubectl top nodes
else
    echo "Metrics Server is not available."
fi

echo ""
echo "Pod Resource Usage"
echo "----------------------------------------"

if kubectl top pods --all-namespaces >/dev/null 2>&1; then
    kubectl top pods --all-namespaces
else
    echo "Metrics Server is not available."
fi

echo ""
echo "========================================"
echo "Resource Usage Retrieved Successfully"
echo "========================================"
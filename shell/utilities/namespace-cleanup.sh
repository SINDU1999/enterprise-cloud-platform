#!/bin/bash

echo "========================================"
echo " Kubernetes Namespace Cleanup Report"
echo "========================================"

echo ""
echo "Checking Namespaces..."
echo "----------------------------------------"

kubectl get namespaces

echo ""
echo "Namespaces in Terminating State"
echo "----------------------------------------"

TERMINATING=$(kubectl get namespaces --no-headers | grep Terminating)

if [ -z "$TERMINATING" ]; then
    echo "No namespaces are in Terminating state."
else
    echo "$TERMINATING"
fi

echo ""
echo "Cleanup Recommendation"
echo "----------------------------------------"
echo "Review namespaces before deleting any resources."
echo "Avoid automatic deletion in production environments."

echo ""
echo "========================================"
echo "Namespace Cleanup Report Generated"
echo "========================================"
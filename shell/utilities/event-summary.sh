#!/bin/bash

echo "========================================"
echo " Kubernetes Event Summary"
echo "========================================"

echo ""
echo "Recent Cluster Events"
echo "----------------------------------------"

kubectl get events --all-namespaces \
    --sort-by='.lastTimestamp'

echo ""
echo "Warning Events"
echo "----------------------------------------"

kubectl get events --all-namespaces \
    --field-selector type=Warning

echo ""
echo "========================================"
echo "Event Summary Retrieved Successfully"
echo "========================================"
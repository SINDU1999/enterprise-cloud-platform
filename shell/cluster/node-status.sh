#!/bin/bash

echo "========================================"
echo " Kubernetes Node Status"
echo "========================================"

kubectl get nodes --no-headers | while read node status roles age version
do
    if [[ "$status" == "Ready" ]]; then
        echo "✅ $node is Ready"
    else
        echo "❌ $node is NOT Ready"
    fi
done

echo ""
echo "Total Nodes:"
kubectl get nodes --no-headers | wc -l

echo "========================================"
echo "Node Status Check Completed"
echo "========================================"
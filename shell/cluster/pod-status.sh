#!/bin/bash

echo "========================================"
echo " Kubernetes Pod Status"
echo "========================================"

kubectl get pods --all-namespaces --no-headers | while read namespace pod ready status restarts age
do
    if [[ "$status" == "Running" ]]; then
        echo "✅ [$namespace] $pod is Running"
    else
        echo "❌ [$namespace] $pod is $status"
    fi
done

echo ""
echo "========================================"
echo "Pod Status Check Completed"
echo "========================================"
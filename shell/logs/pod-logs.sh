#!/bin/bash

echo "========================================"
echo " Kubernetes Pod Logs"
echo "========================================"

kubectl get pods --all-namespaces --no-headers | while read namespace pod rest
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Pod       : $pod"
    echo "============================================================"

    kubectl logs -n "$namespace" "$pod" --tail=20 2>/dev/null || \
    echo "Unable to fetch logs (multiple containers or pod not ready)."
done

echo ""
echo "========================================"
echo "Pod Logs Retrieved Successfully"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Previous Pod Logs"
echo "========================================"

kubectl get pods --all-namespaces --no-headers | while read namespace pod rest
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Pod       : $pod"
    echo "============================================================"

    kubectl logs -n "$namespace" "$pod" --previous --tail=20 2>/dev/null || \
    echo "No previous logs available."
done

echo ""
echo "========================================"
echo "Previous Pod Logs Retrieved Successfully"
echo "========================================"
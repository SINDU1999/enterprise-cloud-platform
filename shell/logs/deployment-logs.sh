#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Logs"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment rest
do
    echo ""
    echo "============================================================"
    echo "Namespace  : $namespace"
    echo "Deployment : $deployment"
    echo "============================================================"

    POD=$(kubectl get pods -n "$namespace" \
        -l app="$deployment" \
        --no-headers \
        -o custom-columns=":metadata.name" | head -1)

    if [ -n "$POD" ]; then
        kubectl logs -n "$namespace" "$POD" --tail=20 2>/dev/null || \
        echo "Unable to retrieve logs."
    else
        echo "No matching pod found for deployment."
    fi
done

echo ""
echo "========================================"
echo "Deployment Logs Retrieved Successfully"
echo "========================================"
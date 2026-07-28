#!/bin/bash

echo "========================================"
echo " Kubernetes Namespace Logs"
echo "========================================"

kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | while read namespace
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "============================================================"

    POD=$(kubectl get pods -n "$namespace" \
        --no-headers \
        -o custom-columns=":metadata.name" | head -1)

    if [ -n "$POD" ]; then
        echo "Pod : $POD"
        echo ""
        kubectl logs -n "$namespace" "$POD" --tail=15 2>/dev/null || \
        echo "Unable to retrieve logs."
    else
        echo "No pods found."
    fi
done

echo ""
echo "========================================"
echo "Namespace Logs Retrieved Successfully"
echo "========================================"
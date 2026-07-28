#!/bin/bash

echo "========================================"
echo " Kubernetes Pod Logs"
echo "========================================"

NAMESPACE="default"

PODS=$(kubectl get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name")

if [ -z "$PODS" ]; then
    echo "No pods found in namespace: $NAMESPACE"
    exit 0
fi

for POD in $PODS
do
    echo ""
    echo "----------------------------------------"
    echo "Logs for Pod: $POD"
    echo "----------------------------------------"

    kubectl logs "$POD" -n "$NAMESPACE" --tail=20
done

echo ""
echo "========================================"
echo "Pod Logs Retrieved Successfully"
echo "========================================"
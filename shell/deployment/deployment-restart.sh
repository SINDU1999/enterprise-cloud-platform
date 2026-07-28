#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Restart"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Deployment: $deployment"
    echo "============================================================"

    kubectl rollout restart deployment/"$deployment" -n "$namespace"

    kubectl rollout status deployment/"$deployment" -n "$namespace" --timeout=60s
done

echo ""
echo "========================================"
echo "All Deployments Restarted Successfully"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Rollout Status"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Deployment: $deployment"
    echo "============================================================"

    kubectl rollout status deployment/"$deployment" -n "$namespace" --timeout=30s
done

echo ""
echo "========================================"
echo "Deployment Rollout Status Retrieved Successfully"
echo "========================================"
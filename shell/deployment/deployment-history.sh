#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment History"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Deployment: $deployment"
    echo "============================================================"

    kubectl rollout history deployment/"$deployment" -n "$namespace"
done

echo ""
echo "========================================"
echo "Deployment History Retrieved Successfully"
echo "========================================"
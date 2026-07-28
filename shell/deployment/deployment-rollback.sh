#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Rollback Information"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Deployment: $deployment"
    echo "============================================================"

    echo "Current rollout history:"
    kubectl rollout history deployment/"$deployment" -n "$namespace"

    echo ""
    echo "Rollback Command (Reference Only):"
    echo "kubectl rollout undo deployment/$deployment -n $namespace"
done

echo ""
echo "========================================"
echo "Deployment Rollback Information Retrieved Successfully"
echo "========================================"
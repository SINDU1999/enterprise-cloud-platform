#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Scale Information"
echo "========================================"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    echo ""
    echo "============================================================"
    echo "Namespace : $namespace"
    echo "Deployment: $deployment"
    echo "============================================================"

    kubectl get deployment "$deployment" -n "$namespace" \
        -o custom-columns="NAME:.metadata.name,DESIRED:.spec.replicas,AVAILABLE:.status.availableReplicas,READY:.status.readyReplicas"
done

echo ""
echo "========================================"
echo "Deployment Scale Information Retrieved Successfully"
echo "========================================"
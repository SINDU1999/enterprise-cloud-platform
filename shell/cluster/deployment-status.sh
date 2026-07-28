#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Status"
echo "========================================"

printf "%-20s %-40s %-12s %-12s %-12s\n" "Namespace" "Deployment" "Desired" "Available" "Status"

kubectl get deployments --all-namespaces --no-headers | while read namespace deployment ready up_to_date available age
do
    desired=$(echo "$ready" | cut -d'/' -f2)
    current=$(echo "$ready" | cut -d'/' -f1)

    if [[ "$current" == "$desired" ]]; then
        status="Healthy"
    else
        status="Not Ready"
    fi

    printf "%-20s %-40s %-12s %-12s %-12s\n" \
        "$namespace" \
        "$deployment" \
        "$desired" \
        "$available" \
        "$status"
done

echo ""
echo "========================================"
echo "Deployment Status Check Completed"
echo "========================================"
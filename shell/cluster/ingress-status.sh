#!/bin/bash

echo "========================================"
echo " Kubernetes Ingress Status"
echo "========================================"

if kubectl get ingress --all-namespaces >/dev/null 2>&1; then
    printf "%-20s %-35s %-40s\n" "Namespace" "Ingress" "Host"

    kubectl get ingress --all-namespaces --no-headers | while read namespace ingress classname hosts address ports age
    do
        printf "%-20s %-35s %-40s\n" \
            "$namespace" \
            "$ingress" \
            "$hosts"
    done
else
    echo "Ingress resource is not available in this cluster."
fi

echo ""
echo "========================================"
echo "Ingress Status Check Completed"
echo "========================================"
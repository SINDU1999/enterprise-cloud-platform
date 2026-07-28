#!/bin/bash

echo "========================================"
echo " Kubernetes Namespace Summary"
echo "========================================"

total_namespaces=$(kubectl get namespaces --no-headers | wc -l)

echo ""
echo "Total Namespaces: $total_namespaces"
echo ""

printf "%-20s %-10s\n" "Namespace" "Pods"
printf "%-20s %-10s\n" "---------" "----"

for namespace in $(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')
do
    pod_count=$(kubectl get pods -n "$namespace" --no-headers 2>/dev/null | wc -l)
    printf "%-20s %-10s\n" "$namespace" "$pod_count"
done

echo ""
echo "========================================"
echo "Namespace Summary Completed"
echo "========================================"
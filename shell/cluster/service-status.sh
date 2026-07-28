#!/bin/bash

echo "========================================"
echo " Kubernetes Service Status"
echo "========================================"

printf "%-20s %-40s %-15s %-15s\n" "Namespace" "Service" "Type" "Cluster-IP"

kubectl get services --all-namespaces --no-headers | while read namespace service type clusterip externalip ports age
do
    printf "%-20s %-40s %-15s %-15s\n" \
        "$namespace" \
        "$service" \
        "$type" \
        "$clusterip"
done

echo ""
echo "========================================"
echo "Service Status Check Completed"
echo "========================================"
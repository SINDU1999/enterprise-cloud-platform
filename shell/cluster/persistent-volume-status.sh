#!/bin/bash

echo "========================================"
echo " Kubernetes Persistent Volume Status"
echo "========================================"

echo ""
echo "Persistent Volumes (PV):"
printf "%-40s %-10s %-10s %-10s\n" "Name" "Capacity" "Status" "StorageClass"

kubectl get pv --no-headers | while read name capacity access reclaim status claim storageclass reason age
do
    printf "%-40s %-10s %-10s %-10s\n" \
        "$name" \
        "$capacity" \
        "$status" \
        "$storageclass"
done

echo ""
echo "Persistent Volume Claims (PVC):"
printf "%-20s %-30s %-10s %-10s\n" "Namespace" "PVC" "Status" "Capacity"

kubectl get pvc --all-namespaces --no-headers | while read namespace pvc status volume capacity access storageclass age
do
    printf "%-20s %-30s %-10s %-10s\n" \
        "$namespace" \
        "$pvc" \
        "$status" \
        "$capacity"
done

echo ""
echo "========================================"
echo "Persistent Volume Status Check Completed"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Kubernetes Manifest Backup"
echo "========================================"

BACKUP_DIR="./backups/manifests/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo ""
echo "Backing up Kubernetes manifests..."
echo "----------------------------------------"

kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | while read namespace
do
    mkdir -p "$BACKUP_DIR/$namespace"

    echo "Backing up namespace: $namespace"

    kubectl get deployment -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/deployments.yaml" 2>/dev/null
    kubectl get service -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/services.yaml" 2>/dev/null
    kubectl get configmap -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/configmaps.yaml" 2>/dev/null
    kubectl get ingress -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/ingresses.yaml" 2>/dev/null
    kubectl get statefulset -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/statefulsets.yaml" 2>/dev/null
    kubectl get daemonset -n "$namespace" -o yaml > "$BACKUP_DIR/$namespace/daemonsets.yaml" 2>/dev/null
done

echo ""
echo "Backup Location:"
echo "$BACKUP_DIR"

echo ""
echo "========================================"
echo "Manifest Backup Completed Successfully"
echo "========================================"
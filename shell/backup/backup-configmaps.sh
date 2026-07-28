#!/bin/bash

echo "========================================"
echo " Kubernetes ConfigMap Backup"
echo "========================================"

BACKUP_DIR="./backups/configmaps/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo ""
echo "Backing up ConfigMaps..."
echo "----------------------------------------"

kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | while read namespace
do
    mkdir -p "$BACKUP_DIR/$namespace"

    kubectl get configmaps -n "$namespace" -o yaml \
        > "$BACKUP_DIR/$namespace/configmaps.yaml" 2>/dev/null

    COUNT=$(kubectl get configmaps -n "$namespace" --no-headers 2>/dev/null | wc -l)

    echo "Namespace: $namespace | ConfigMaps: $COUNT"
done

echo ""
echo "Backup Location:"
echo "$BACKUP_DIR"

echo ""
echo "========================================"
echo "ConfigMap Backup Completed Successfully"
echo "========================================"
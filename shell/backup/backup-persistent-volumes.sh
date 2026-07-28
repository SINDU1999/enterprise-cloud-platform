#!/bin/bash

echo "========================================"
echo " Kubernetes Persistent Storage Backup"
echo "========================================"

BACKUP_DIR="./backups/storage/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo ""
echo "Backing up Persistent Volumes..."
echo "----------------------------------------"

kubectl get pv -o yaml > "$BACKUP_DIR/persistent-volumes.yaml" 2>/dev/null

echo "Backing up Persistent Volume Claims..."
echo "----------------------------------------"

kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | while read namespace
do
    kubectl get pvc -n "$namespace" -o yaml \
        > "$BACKUP_DIR/pvc-$namespace.yaml" 2>/dev/null

    COUNT=$(kubectl get pvc -n "$namespace" --no-headers 2>/dev/null | wc -l)

    echo "Namespace: $namespace | PVCs: $COUNT"
done

PV_COUNT=$(kubectl get pv --no-headers 2>/dev/null | wc -l)

echo ""
echo "----------------------------------------"
echo "Total Persistent Volumes : $PV_COUNT"
echo "Backup Location          : $BACKUP_DIR"

echo ""
echo "========================================"
echo "Persistent Storage Backup Completed Successfully"
echo "========================================"
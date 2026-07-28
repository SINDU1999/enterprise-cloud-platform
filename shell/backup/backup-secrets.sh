#!/bin/bash

echo "========================================"
echo " Kubernetes Secrets Backup"
echo "========================================"

BACKUP_DIR="./backups/secrets/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

echo ""
echo "Backing up Secret metadata..."
echo "----------------------------------------"

kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | while read namespace
do
    mkdir -p "$BACKUP_DIR/$namespace"

    kubectl get secrets -n "$namespace" \
        -o custom-columns="NAME:.metadata.name,TYPE:.type" \
        > "$BACKUP_DIR/$namespace/secrets.txt" 2>/dev/null

    COUNT=$(kubectl get secrets -n "$namespace" --no-headers 2>/dev/null | wc -l)

    echo "Namespace: $namespace | Secrets: $COUNT"
done

echo ""
echo "Backup Location:"
echo "$BACKUP_DIR"

echo ""
echo "========================================"
echo "Secret Metadata Backup Completed Successfully"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Kubernetes ETCD Backup"
echo "========================================"

BACKUP_DIR="./backups/etcd"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$BACKUP_DIR"

echo ""
echo "Checking Kubernetes Environment..."
echo "----------------------------------------"

if kubectl cluster-info | grep -qi "eks"; then
    echo "Managed Kubernetes Detected : Amazon EKS"
    echo ""
    echo "ETCD is managed by AWS and cannot be backed up directly from worker nodes."
    echo "Use AWS EKS cluster backup strategies such as:"
    echo " - Velero"
    echo " - AWS Backup"
    echo " - Infrastructure as Code (Terraform)"
else
    echo "Self-managed Kubernetes detected."

    if command -v etcdctl >/dev/null 2>&1; then
        echo ""
        echo "Example snapshot command:"
        echo "etcdctl snapshot save $BACKUP_DIR/etcd-snapshot-$TIMESTAMP.db"
    else
        echo "etcdctl is not installed."
    fi
fi

echo ""
echo "========================================"
echo "ETCD Backup Check Completed"
echo "========================================"
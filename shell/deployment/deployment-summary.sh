#!/bin/bash

echo "========================================"
echo " Kubernetes Deployment Summary"
echo "========================================"

TOTAL_DEPLOYMENTS=$(kubectl get deployments --all-namespaces --no-headers | wc -l)

READY_DEPLOYMENTS=$(kubectl get deployments --all-namespaces --no-headers | \
awk '$2==$3 {count++} END {print count+0}')

echo ""
echo "Deployment Summary"
echo "----------------------------------------"
echo "Total Deployments : $TOTAL_DEPLOYMENTS"
echo "Ready Deployments : $READY_DEPLOYMENTS"

echo ""
echo "Deployment Details"
echo "----------------------------------------"

kubectl get deployments --all-namespaces \
-o custom-columns=\
"NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
READY:.status.readyReplicas,\
DESIRED:.spec.replicas,\
AVAILABLE:.status.availableReplicas"

echo ""

if [ "$TOTAL_DEPLOYMENTS" -eq "$READY_DEPLOYMENTS" ]; then
    echo "Overall Deployment Status : HEALTHY ✅"
else
    echo "Overall Deployment Status : ATTENTION REQUIRED ⚠️"
fi

echo ""
echo "========================================"
echo "Deployment Summary Generated Successfully"
echo "========================================"
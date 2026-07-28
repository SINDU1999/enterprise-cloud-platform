#!/bin/bash

echo "========================================"
echo " Loki Status"
echo "========================================"

NAMESPACE="monitoring"

echo ""
echo "Checking Loki Pods..."
echo "----------------------------------------"

kubectl get pods -n "$NAMESPACE" | grep loki || \
echo "No Loki pods found."

echo ""
echo "Checking Loki Services..."
echo "----------------------------------------"

kubectl get svc -n "$NAMESPACE" | grep loki || \
echo "No Loki services found."

echo ""
echo "Checking Loki StatefulSets..."
echo "----------------------------------------"

kubectl get statefulset -n "$NAMESPACE" | grep loki || \
echo "No Loki StatefulSets found."

echo ""
echo "Checking Loki Deployments..."
echo "----------------------------------------"

kubectl get deployment -n "$NAMESPACE" | grep loki || \
echo "No Loki Deployments found."

echo ""
echo "========================================"
echo "Loki Status Retrieved Successfully"
echo "========================================"
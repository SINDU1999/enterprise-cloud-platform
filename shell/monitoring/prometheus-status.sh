#!/bin/bash

echo "========================================"
echo " Prometheus Status"
echo "========================================"

NAMESPACE="monitoring"
APP_LABEL="app.kubernetes.io/name=prometheus"

echo ""
echo "Checking Prometheus Pods..."
echo "----------------------------------------"

kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL"

echo ""
echo "Checking Prometheus Services..."
echo "----------------------------------------"

kubectl get svc -n "$NAMESPACE" | grep prometheus

echo ""
echo "Checking Prometheus StatefulSet..."
echo "----------------------------------------"

kubectl get statefulset -n "$NAMESPACE" | grep prometheus

echo ""
echo "========================================"
echo "Prometheus Status Retrieved Successfully"
echo "========================================"
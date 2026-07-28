#!/bin/bash

echo "========================================"
echo " Node Exporter Status"
echo "========================================"

NAMESPACE="monitoring"
APP_LABEL="app.kubernetes.io/name=node-exporter"

echo ""
echo "Checking Node Exporter Pods..."
echo "----------------------------------------"

kubectl get pods -n "$NAMESPACE" | grep node-exporter || \
echo "No Node Exporter pods found."

echo ""
echo "Checking Node Exporter Service..."
echo "----------------------------------------"

kubectl get svc -n "$NAMESPACE" | grep node-exporter

echo ""
echo "Checking Node Exporter DaemonSet..."
echo "----------------------------------------"

kubectl get daemonset -n "$NAMESPACE" | grep node-exporter

echo ""
echo "========================================"
echo "Node Exporter Status Retrieved Successfully"
echo "========================================"
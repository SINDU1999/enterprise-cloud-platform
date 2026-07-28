#!/bin/bash

echo "========================================"
echo " Grafana Status"
echo "========================================"

NAMESPACE="monitoring"
APP_LABEL="app.kubernetes.io/name=grafana"

echo ""
echo "Checking Grafana Pods..."
echo "----------------------------------------"

kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL"

echo ""
echo "Checking Grafana Services..."
echo "----------------------------------------"

kubectl get svc -n "$NAMESPACE" | grep grafana

echo ""
echo "Checking Grafana Deployment..."
echo "----------------------------------------"

kubectl get deployment -n "$NAMESPACE" | grep grafana

echo ""
echo "========================================"
echo "Grafana Status Retrieved Successfully"
echo "========================================"
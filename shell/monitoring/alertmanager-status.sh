#!/bin/bash

echo "========================================"
echo " Alertmanager Status"
echo "========================================"

NAMESPACE="monitoring"
APP_LABEL="app.kubernetes.io/name=alertmanager"

echo ""
echo "Checking Alertmanager Pods..."
echo "----------------------------------------"

kubectl get pods -n "$NAMESPACE" -l "$APP_LABEL"

echo ""
echo "Checking Alertmanager Services..."
echo "----------------------------------------"

kubectl get svc -n "$NAMESPACE" | grep alertmanager

echo ""
echo "Checking Alertmanager StatefulSet..."
echo "----------------------------------------"

kubectl get statefulset -n "$NAMESPACE" | grep alertmanager

echo ""
echo "========================================"
echo "Alertmanager Status Retrieved Successfully"
echo "========================================"
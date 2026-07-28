#!/bin/bash

echo "========================================"
echo " Monitoring Stack Summary"
echo "========================================"

NAMESPACE="monitoring"

echo ""
echo "Monitoring Components"
echo "----------------------------------------"

PROMETHEUS=$(kubectl get pods -n "$NAMESPACE" | grep -c prometheus)
GRAFANA=$(kubectl get pods -n "$NAMESPACE" | grep -c grafana)
ALERTMANAGER=$(kubectl get pods -n "$NAMESPACE" | grep -c alertmanager)
NODE_EXPORTER=$(kubectl get pods -n "$NAMESPACE" | grep -c node-exporter)
LOKI=$(kubectl get pods -n "$NAMESPACE" | grep -c loki)

echo "Prometheus Pods   : $PROMETHEUS"
echo "Grafana Pods      : $GRAFANA"
echo "Alertmanager Pods : $ALERTMANAGER"
echo "Node Exporter Pods: $NODE_EXPORTER"
echo "Loki Pods         : $LOKI"

echo ""
echo "Cluster Health"
echo "----------------------------------------"

TOTAL=$(kubectl get pods -n "$NAMESPACE" --no-headers | wc -l)
RUNNING=$(kubectl get pods -n "$NAMESPACE" --no-headers | grep Running | wc -l)

echo "Total Monitoring Pods   : $TOTAL"
echo "Running Monitoring Pods : $RUNNING"

if [ "$TOTAL" -eq "$RUNNING" ]; then
    echo ""
    echo "Overall Status : HEALTHY ✅"
else
    echo ""
    echo "Overall Status : ATTENTION REQUIRED ⚠️"
fi

echo ""
echo "========================================"
echo "Monitoring Summary Generated Successfully"
echo "========================================"
#!/bin/bash

echo "========================================"
echo " Kubernetes Log Summary"
echo "========================================"

TOTAL_PODS=$(kubectl get pods --all-namespaces --no-headers | wc -l)

RUNNING_PODS=$(kubectl get pods --all-namespaces --no-headers | grep "Running" | wc -l)

FAILED_PODS=$(kubectl get pods --all-namespaces --no-headers | \
grep -E "CrashLoopBackOff|Error|ImagePullBackOff|ErrImagePull" | wc -l)

COMPLETED_PODS=$(kubectl get pods --all-namespaces --no-headers | \
grep "Completed" | wc -l)

PENDING_PODS=$(kubectl get pods --all-namespaces --no-headers | \
grep "Pending" | wc -l)

echo ""
echo "Cluster Log Summary"
echo "----------------------------"
echo "Total Pods      : $TOTAL_PODS"
echo "Running Pods    : $RUNNING_PODS"
echo "Failed Pods     : $FAILED_PODS"
echo "Completed Pods  : $COMPLETED_PODS"
echo "Pending Pods    : $PENDING_PODS"

echo ""
echo "========================================"
echo "Log Summary Generated Successfully"
echo "========================================"
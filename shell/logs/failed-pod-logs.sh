#!/bin/bash

echo "========================================"
echo " Failed Pod Logs"
echo "========================================"

kubectl get pods --all-namespaces --no-headers | while read namespace pod ready status rest
do
    if [[ "$status" == "CrashLoopBackOff" || "$status" == "Error" || "$status" == "ImagePullBackOff" || "$status" == "ErrImagePull" ]]; then

        echo ""
        echo "============================================================"
        echo "Namespace : $namespace"
        echo "Pod       : $pod"
        echo "Status    : $status"
        echo "============================================================"

        kubectl logs -n "$namespace" "$pod" --tail=30 2>/dev/null || \
        echo "Unable to retrieve logs."
    fi
done

echo ""
echo "========================================"
echo "Failed Pod Logs Retrieved Successfully"
echo "========================================"
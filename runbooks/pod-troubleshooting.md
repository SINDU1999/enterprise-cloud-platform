# Kubernetes Pod Troubleshooting Runbook

## Purpose

This runbook provides a standard approach for diagnosing and resolving issues related to Kubernetes pods running on the Enterprise Cloud Platform.

It helps CloudOps and DevOps engineers quickly identify pod failures, determine root causes, and restore application availability.

---

# Scope

This runbook applies to all Kubernetes workloads running in:

- Development
- QA
- Production

---

# Prerequisites

Before troubleshooting:

- AWS CLI configured
- kubectl installed
- Access to the EKS cluster
- Required IAM permissions

Verify cluster connectivity:

```bash
kubectl get nodes
kubectl get pods -A
```

---

# Step 1 – Identify the Problem

List all pods:

```bash
kubectl get pods -A
```

Look for pod states such as:

- CrashLoopBackOff
- ImagePullBackOff
- Pending
- Error
- Completed
- Running

---

# Step 2 – Describe the Pod

Display detailed information:

```bash
kubectl describe pod <pod-name> -n <namespace>
```

Review:

- Events
- Container status
- Restart count
- Scheduling errors

---

# Step 3 – Review Logs

Current container logs:

```bash
kubectl logs <pod-name> -n <namespace>
```

Previous container logs:

```bash
kubectl logs <pod-name> --previous -n <namespace>
```

---

# Step 4 – Verify Deployment

Check deployment:

```bash
kubectl get deployment -n <namespace>
```

Describe deployment:

```bash
kubectl describe deployment <deployment-name> -n <namespace>
```

---

# Common Issues

## CrashLoopBackOff

Possible causes:

- Application startup failure
- Invalid configuration
- Missing Secrets
- Missing ConfigMaps
- Database connection failure

Commands:

```bash
kubectl logs <pod-name>

kubectl describe pod <pod-name>
```

---

## ImagePullBackOff

Possible causes:

- Incorrect image name
- Incorrect image tag
- Private registry authentication failure
- Image does not exist

Verify image:

```bash
kubectl describe pod <pod-name>
```

---

## Pending Pods

Possible causes:

- Insufficient CPU
- Insufficient Memory
- No available nodes
- Node Selector mismatch
- Taints and tolerations

Verify:

```bash
kubectl describe pod <pod-name>
```

---

## OOMKilled

Indicates the container exceeded its memory limit.

Verify:

```bash
kubectl describe pod <pod-name>
```

Review:

- Resource limits
- Resource requests

---

## ContainerCreating

Possible causes:

- Persistent Volume issues
- Secret mounting issues
- Image download in progress

Check events:

```bash
kubectl describe pod <pod-name>
```

---

# Restart Analysis

View restart count:

```bash
kubectl get pods
```

Large restart counts may indicate:

- Memory leaks
- Configuration issues
- External dependency failures

---

# Resource Usage

View node resource usage:

```bash
kubectl top nodes
```

View pod resource usage:

```bash
kubectl top pods
```

---

# Network Verification

Verify service:

```bash
kubectl get svc
```

Verify endpoints:

```bash
kubectl get endpoints
```

---

# Escalation

Escalate if:

- Production outage
- Multiple applications affected
- Cluster-wide issues
- Infrastructure failures
- Security incidents

---

# Best Practices

- Investigate events before restarting pods.
- Review logs before deleting resources.
- Avoid deleting production pods without understanding the root cause.
- Record findings for future reference.
- Monitor application health after recovery.

---

# Related Runbooks

- Amazon EKS Cluster Operations
- Application Deployment
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
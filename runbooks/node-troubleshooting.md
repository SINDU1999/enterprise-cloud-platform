# Kubernetes Node Troubleshooting Runbook

## Purpose

This runbook provides procedures for diagnosing and resolving Kubernetes worker node issues within the Enterprise Cloud Platform running on Amazon EKS.

It covers node health checks, scheduling issues, resource exhaustion, networking, and recovery procedures.

---

# Scope

This runbook applies to all worker nodes in:

- Development
- QA
- Production

---

# Prerequisites

Ensure the following before troubleshooting:

- AWS CLI configured
- kubectl installed
- Access to the EKS cluster
- IAM permissions to view cluster resources

Verify cluster access:

```bash
kubectl get nodes
```

---

# Step 1 – Check Node Status

List all nodes:

```bash
kubectl get nodes
```

Healthy nodes should display:

```
STATUS: Ready
```

Investigate any nodes showing:

- NotReady
- SchedulingDisabled
- Unknown

---

# Step 2 – Describe the Node

View detailed information:

```bash
kubectl describe node <node-name>
```

Review:

- Conditions
- Capacity
- Allocatable resources
- Events
- Taints

---

# Step 3 – Verify Resource Utilization

Check CPU and memory usage:

```bash
kubectl top nodes
```

Look for:

- High CPU utilization
- High memory usage
- Resource exhaustion

---

# Step 4 – Review Running Pods

View workloads on the node:

```bash
kubectl get pods -A -o wide
```

Identify pods assigned to the affected node.

---

# Common Node Issues

## Node NotReady

Possible causes:

- EC2 instance unavailable
- Kubelet failure
- Network connectivity issues
- Disk pressure

Check:

```bash
kubectl describe node <node-name>
```

---

## Memory Pressure

Symptoms:

- Pods evicted
- OOMKilled containers
- High memory utilization

Verify:

```bash
kubectl top nodes
```

---

## Disk Pressure

Possible causes:

- Log files consuming storage
- Container image accumulation
- Full root volume

Review node conditions using:

```bash
kubectl describe node <node-name>
```

---

## CPU Pressure

High CPU usage may cause:

- Slow scheduling
- Application latency
- Delayed deployments

Review workloads running on the node.

---

## Network Issues

Verify:

```bash
kubectl get nodes -o wide
```

Check:

- Node IP
- Internal networking
- Security Groups
- VPC routing

---

# Cordon a Node

Prevent new pods from being scheduled:

```bash
kubectl cordon <node-name>
```

---

# Drain a Node

Safely evict workloads:

```bash
kubectl drain <node-name> --ignore-daemonsets
```

---

# Uncordon a Node

Return the node to service:

```bash
kubectl uncordon <node-name>
```

---

# Verify Recovery

Confirm:

```bash
kubectl get nodes
```

Ensure:

- Node status is Ready
- Pods are running
- No failed scheduling events

---

# Best Practices

- Monitor node resource utilization regularly.
- Investigate alerts before nodes become unavailable.
- Drain nodes before maintenance.
- Avoid manual changes on production nodes.
- Keep worker nodes updated through managed EKS upgrades.

---

# Related Runbooks

- Amazon EKS Cluster Operations
- Pod Troubleshooting
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
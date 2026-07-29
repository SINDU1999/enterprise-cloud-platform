# Amazon EKS Cluster Operations Runbook

## Purpose

This runbook describes the standard operating procedures for managing the Amazon Elastic Kubernetes Service (Amazon EKS) cluster used by the Enterprise Cloud Platform.

It includes cluster health checks, node management, deployment verification, scaling operations, troubleshooting, and maintenance activities.

---

# Scope

This runbook applies to:

- Development
- QA
- Production

The EKS platform hosts containerized applications deployed using Kubernetes and Helm.

---

# Prerequisites

Before performing cluster operations, ensure:

- AWS CLI is configured
- kubectl is installed
- Correct kubeconfig is configured
- Required IAM permissions are available

Verify access:

```bash
aws sts get-caller-identity

kubectl get nodes
```

---

# Cluster Health Check

Verify cluster information:

```bash
aws eks list-clusters

aws eks describe-cluster --name fincore-dev-eks-cluster
```

Check Kubernetes nodes:

```bash
kubectl get nodes
```

Expected status:

```
Ready
```

---

# Verify System Pods

```bash
kubectl get pods -A
```

Verify that system pods are running successfully.

---

# View Cluster Resources

View namespaces:

```bash
kubectl get namespaces
```

View deployments:

```bash
kubectl get deployments -A
```

View services:

```bash
kubectl get svc -A
```

View ingress resources:

```bash
kubectl get ingress -A
```

---

# Node Operations

View nodes:

```bash
kubectl get nodes -o wide
```

Describe a node:

```bash
kubectl describe node <node-name>
```

Drain a node before maintenance:

```bash
kubectl drain <node-name> --ignore-daemonsets
```

Enable scheduling again:

```bash
kubectl uncordon <node-name>
```

---

# Pod Operations

List pods:

```bash
kubectl get pods -A
```

Describe a pod:

```bash
kubectl describe pod <pod-name>
```

View logs:

```bash
kubectl logs <pod-name>
```

View logs of previous container:

```bash
kubectl logs <pod-name> --previous
```

Execute into a pod:

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

---

# Scaling Deployments

Scale manually:

```bash
kubectl scale deployment <deployment-name> --replicas=3
```

Verify:

```bash
kubectl get deployment
```

---

# Rolling Restart

Restart deployment:

```bash
kubectl rollout restart deployment <deployment-name>
```

Check rollout:

```bash
kubectl rollout status deployment <deployment-name>
```

---

# Common Troubleshooting

## CrashLoopBackOff

Check:

```bash
kubectl logs <pod-name>

kubectl describe pod <pod-name>
```

Possible causes:

- Application crash
- Configuration errors
- Missing environment variables
- Secret issues

---

## ImagePullBackOff

Verify:

- Image name
- Image tag
- Registry authentication
- Image availability

---

## Pending Pods

Check:

```bash
kubectl describe pod <pod-name>
```

Possible causes:

- Insufficient CPU
- Insufficient memory
- Node scheduling constraints

---

## Node Not Ready

Verify:

```bash
kubectl get nodes

kubectl describe node <node-name>
```

Review:

- Node conditions
- Kubelet status
- EC2 instance health

---

# Cluster Monitoring

Monitor:

- Node health
- Pod health
- CPU utilization
- Memory utilization
- Network traffic
- Disk usage

Use:

- CloudWatch
- Prometheus
- Grafana

---

# Best Practices

- Monitor cluster health daily.
- Avoid manual changes to cluster resources.
- Use rolling deployments.
- Validate deployments after release.
- Monitor application logs after every deployment.
- Keep Kubernetes manifests under version control.

---

# Related Runbooks

- Terraform Operations
- Application Deployment
- Pod Troubleshooting
- Node Troubleshooting
- CloudWatch Monitoring

---

# Document Version

Version: 1.0

Status: Active
# Deployment Guide

## Overview

This document describes the standard deployment workflow for applications on the Enterprise Cloud Platform.

The deployment process uses GitHub for source control, GitHub Actions and Jenkins for CI/CD automation, Docker for containerization, Helm for Kubernetes package management, ArgoCD for GitOps synchronization, and Amazon EKS for application hosting.

---

# Deployment Workflow

```
Developer
    │
    ▼
Git Commit
    │
    ▼
GitHub Repository
    │
    ├──────────────► GitHub Actions
    │                     │
    ▼                     ▼
 Jenkins Pipeline     Docker Image Build
         │                    │
         └──────────────► Container Registry
                               │
                               ▼
                        Helm Chart Update
                               │
                               ▼
                         ArgoCD Synchronization
                               │
                               ▼
                          Amazon EKS Cluster
                               │
                               ▼
                         Running Application
```

---

# Deployment Prerequisites

Before deployment, ensure:

- Source code changes are reviewed and approved
- Terraform infrastructure is deployed
- Amazon EKS cluster is healthy
- Docker image repository is accessible
- Helm charts are updated
- ArgoCD is synchronized
- Required IAM permissions are available

---

# Deployment Steps

## Step 1 – Commit Code

Developers commit application changes to the GitHub repository.

Example:

```bash
git add .
git commit -m "Feature update"
git push origin main
```

---

## Step 2 – Continuous Integration

The CI pipeline performs:

- Source code checkout
- Dependency installation
- Build
- Unit tests
- Static analysis
- Docker image creation

---

## Step 3 – Build Docker Image

Example:

```bash
docker build -t enterprise-app:v1 .
```

Verify:

```bash
docker images
```

---

## Step 4 – Push Container Image

Push the image to the configured container registry.

Example:

```bash
docker push <repository>/enterprise-app:v1
```

---

## Step 5 – Update Helm Configuration

Update the image tag in the Helm values file.

Example:

```yaml
image:
  repository: enterprise-app
  tag: v1
```

Commit the updated Helm configuration.

---

## Step 6 – Deploy to Kubernetes

Applications are deployed to Amazon EKS using Helm.

Example:

```bash
helm upgrade enterprise-app ./helm
```

ArgoCD synchronizes the cluster with the Git repository.

---

## Step 7 – Verify Deployment

Verify deployment status:

```bash
kubectl get deployments
kubectl get pods
kubectl get svc
```

Check rollout status:

```bash
kubectl rollout status deployment/<deployment-name>
```

---

# Rollback Procedure

If deployment issues occur:

Rollback Kubernetes deployment:

```bash
kubectl rollout undo deployment/<deployment-name>
```

Rollback Helm release:

```bash
helm rollback <release-name>
```

Verify that the application is healthy after rollback.

---

# Post-Deployment Validation

Confirm:

- Pods are running
- Services are available
- Ingress is accessible
- CloudWatch shows no active alarms
- Application logs contain no critical errors

---

# Best Practices

- Use versioned Docker image tags.
- Validate deployments in development before promoting to production.
- Use Infrastructure as Code for all platform resources.
- Monitor deployments after release.
- Keep deployment artifacts under version control.

---

# Related Documents

- architecture.md
- ci-cd.md
- monitoring.md
- troubleshooting.md

---

# Document Version

Version: 1.0

Status: Active
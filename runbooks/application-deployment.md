# Application Deployment Runbook

## Purpose

This runbook describes the standard deployment process for applications running on the Enterprise Cloud Platform.

It covers source code changes, CI/CD pipelines, container image creation, Kubernetes deployment, validation, rollback, and post-deployment verification.

---

# Scope

This runbook applies to:

- Development
- QA
- Production

Applications are deployed on Amazon EKS using Docker containers and Kubernetes manifests managed through Helm and ArgoCD.

---

# Prerequisites

Before deploying an application:

- Source code has been reviewed and approved
- Required permissions are available
- CI/CD pipelines are operational
- Kubernetes cluster is healthy
- Container registry is accessible

Verify cluster connectivity:

```bash
kubectl get nodes
kubectl get pods -A
```

---

# Deployment Workflow

## Step 1 – Pull Latest Code

```bash
git pull
```

Ensure you are on the correct branch.

---

## Step 2 – Build Application

Example:

```bash
mvn clean package
```

or

```bash
npm install
npm run build
```

depending on the application.

---

## Step 3 – Build Docker Image

```bash
docker build -t enterprise-app:v1 .
```

Verify:

```bash
docker images
```

---

## Step 4 – Push Image

Authenticate with your container registry and push the image.

Example:

```bash
docker push <repository>/enterprise-app:v1
```

---

## Step 5 – Update Deployment

Update the image tag in the Helm values or Kubernetes deployment manifest.

Example:

```yaml
image:
  repository: enterprise-app
  tag: v1
```

Commit the change to Git.

---

## Step 6 – Deploy

Deployment may occur through:

- GitHub Actions
- Jenkins
- ArgoCD synchronization
- Helm upgrade

Example:

```bash
helm upgrade enterprise-app ./helm
```

---

## Step 7 – Verify Deployment

Check deployment status:

```bash
kubectl get deployments
```

Verify rollout:

```bash
kubectl rollout status deployment/<deployment-name>
```

Verify pods:

```bash
kubectl get pods
```

Verify services:

```bash
kubectl get svc
```

---

# Post-Deployment Validation

Verify:

- Application starts successfully
- Pods are running
- Services are accessible
- Logs contain no critical errors
- Metrics are healthy
- CloudWatch shows no alarms

Check logs:

```bash
kubectl logs <pod-name>
```

---

# Rollback Procedure

If deployment fails:

Rollback using Kubernetes:

```bash
kubectl rollout undo deployment/<deployment-name>
```

Or rollback using Helm:

```bash
helm rollback <release-name>
```

Verify application health after rollback.

---

# Common Deployment Issues

## ImagePullBackOff

Possible causes:

- Incorrect image name
- Missing image tag
- Registry authentication failure

---

## CrashLoopBackOff

Possible causes:

- Application startup failure
- Missing environment variables
- Invalid configuration
- Secret issues

Review:

```bash
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

---

## Failed Rollout

Check:

```bash
kubectl rollout status deployment/<deployment-name>
kubectl describe deployment <deployment-name>
```

---

# Best Practices

- Deploy through approved CI/CD pipelines.
- Use versioned Docker image tags.
- Avoid deploying directly to production without testing.
- Validate deployment before notifying stakeholders.
- Monitor the application after deployment.
- Keep deployment manifests under version control.

---

# Related Runbooks

- Terraform Operations
- Amazon EKS Cluster Operations
- Pod Troubleshooting
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
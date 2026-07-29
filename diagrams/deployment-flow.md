# Deployment Workflow

```mermaid
flowchart LR

Developer --> GitHub

GitHub --> GitHubActions

GitHubActions --> DockerBuild

DockerBuild --> Registry

Registry --> Helm

Helm --> ArgoCD

ArgoCD --> AmazonEKS

AmazonEKS --> RunningApplication
```
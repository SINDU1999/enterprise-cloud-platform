# Monitoring Workflow

```mermaid
flowchart LR

Applications --> CloudWatch

AmazonEKS --> CloudWatch

AmazonRDS --> CloudWatch

CloudWatch --> Dashboards

CloudWatch --> Alarms

Alarms --> OperationsTeam
```
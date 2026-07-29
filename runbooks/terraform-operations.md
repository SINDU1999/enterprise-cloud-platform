# Terraform Operations Runbook

## Purpose

This runbook defines the standard operating procedure for managing infrastructure using Terraform within the Enterprise Cloud Platform.

It covers planning, deployment, validation, rollback considerations, and troubleshooting while ensuring infrastructure changes remain consistent and auditable.

---

# Scope

This runbook applies to:

- Development
- QA
- Production

Terraform manages:

- VPC
- Security Groups
- IAM
- EKS
- Route53
- RDS
- KMS
- Secrets Manager
- CloudWatch

---

# Prerequisites

Before executing Terraform:

- AWS CLI configured
- Terraform installed
- Valid AWS credentials
- Correct AWS Region selected
- Git repository up to date

Verify:

```bash
terraform version
aws sts get-caller-identity
```

---

# Standard Deployment Workflow

## Step 1

Pull the latest repository changes.

```bash
git pull
```

---

## Step 2

Initialize Terraform.

```bash
terraform init
```

---

## Step 3

Format Terraform files.

```bash
terraform fmt
```

---

## Step 4

Validate configuration.

```bash
terraform validate
```

---

## Step 5

Review execution plan.

```bash
terraform plan
```

Verify:

- Resources to be created
- Resources to be modified
- Resources to be destroyed

Never continue without reviewing the execution plan.

---

## Step 6

Deploy infrastructure.

```bash
terraform apply
```

Confirm with:

```
yes
```

---

## Step 7

Validate infrastructure.

Verify resources in:

- AWS Console
- CloudWatch
- Route53
- EKS
- RDS

---

# Standard Change Process

Infrastructure changes should follow:

1. Modify code
2. Validate
3. Plan
4. Peer review (if applicable)
5. Apply
6. Verify
7. Commit changes
8. Push to repository

---

# Rollback

If deployment fails:

- Review Terraform output
- Correct configuration
- Execute terraform plan again
- Apply corrected configuration

Avoid manually deleting managed resources unless absolutely necessary.

---

# Troubleshooting

## terraform init

Possible issues:

- Provider download failures
- Invalid credentials

Verify:

```bash
aws configure list
```

---

## terraform validate

Possible issues:

- Invalid syntax
- Missing variables
- Unsupported arguments

Correct the configuration before proceeding.

---

## terraform plan

Possible issues:

- Unexpected resource recreation
- Incorrect variable values
- Missing imports

Review carefully before deployment.

---

## terraform apply

Possible issues:

- AWS API validation errors
- Resource already exists
- Permission denied
- Unsupported engine versions
- Dependency failures

Review the error message and correct the configuration before retrying.

---

# Best Practices

- Always run terraform fmt.
- Always validate before planning.
- Never skip reviewing the execution plan.
- Avoid manual infrastructure changes.
- Commit Terraform code after successful deployment.
- Keep modules reusable and version controlled.

---

# Related Runbooks

- EKS Cluster Operations
- RDS Operations
- Route53 DNS
- CloudWatch Monitoring
- Disaster Recovery

---

# Document Version

Version: 1.0

Status: Active
# AWS Secrets Manager Operations Runbook

## Purpose

This runbook provides operational procedures for securely managing application secrets using AWS Secrets Manager within the Enterprise Cloud Platform.

It covers secret creation, retrieval, rotation, monitoring, access control, and troubleshooting.

---

# Scope

This runbook applies to all environments:

- Development
- QA
- Production

Secrets managed include:

- Database credentials
- API keys
- Application passwords
- Third-party service credentials
- Authentication tokens

---

# Prerequisites

Before managing secrets:

- AWS CLI configured
- IAM permissions for AWS Secrets Manager
- Access to the AWS Management Console

Verify access:

```bash
aws secretsmanager list-secrets
```

---

# Step 1 – View Existing Secrets

List all secrets:

```bash
aws secretsmanager list-secrets
```

Verify:

- Secret name
- Description
- Last changed date
- Rotation status

---

# Step 2 – Retrieve a Secret

Retrieve the current secret value:

```bash
aws secretsmanager get-secret-value \
--secret-id <secret-name>
```

Ensure only authorized users access secret values.

---

# Step 3 – Create a New Secret

Create a new secret:

```bash
aws secretsmanager create-secret \
--name <secret-name> \
--secret-string '{"username":"admin","password":"password"}'
```

Verify successful creation.

---

# Step 4 – Update a Secret

Update an existing secret:

```bash
aws secretsmanager update-secret \
--secret-id <secret-name> \
--secret-string '{"password":"new-password"}'
```

Confirm applications continue to function after the update.

---

# Step 5 – Enable Rotation

Enable automatic rotation where supported.

Verify:

- Rotation schedule
- Rotation Lambda (if applicable)
- Successful rotation history

---

# Common Issues

## Secret Not Found

Possible causes:

- Incorrect secret name
- Secret deleted
- Wrong AWS Region

Verify:

```bash
aws secretsmanager list-secrets
```

---

## Access Denied

Possible causes:

- Missing IAM permissions
- Incorrect IAM policy
- Resource policy restrictions

Review IAM roles and policies.

---

## Application Authentication Failure

Possible causes:

- Incorrect secret value
- Expired credentials
- Secret updated but application not restarted

Verify the application is using the latest secret.

---

# Security Best Practices

- Store sensitive information only in AWS Secrets Manager.
- Never hardcode credentials in source code.
- Enable automatic rotation whenever possible.
- Grant least-privilege IAM access.
- Audit secret access regularly using AWS CloudTrail.

---

# Monitoring

Monitor:

- Secret access events
- Failed retrieval attempts
- Rotation failures
- CloudTrail logs
- CloudWatch alarms

---

# Related Runbooks

- Application Deployment
- Amazon RDS Operations
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
# Amazon Route 53 DNS Operations Runbook

## Purpose

This runbook provides operational procedures for managing DNS records and hosted zones using Amazon Route 53 in the Enterprise Cloud Platform.

It covers DNS record management, hosted zone administration, health checks, troubleshooting, and validation.

---

# Scope

This runbook applies to:

- Development
- QA
- Production

DNS resources managed through Amazon Route 53.

---

# Prerequisites

Before making DNS changes:

- AWS CLI configured
- IAM permissions for Route 53
- Access to the AWS Management Console
- Hosted Zone ID available

---

# Step 1 – Verify Hosted Zones

List hosted zones:

```bash
aws route53 list-hosted-zones
```

Verify:

- Hosted zone exists
- Domain name is correct
- Hosted Zone ID is correct

---

# Step 2 – Review DNS Records

List resource record sets:

```bash
aws route53 list-resource-record-sets \
--hosted-zone-id <hosted-zone-id>
```

Review:

- A Records
- CNAME Records
- Alias Records
- TXT Records
- MX Records

---

# Step 3 – Verify DNS Resolution

Using nslookup:

```bash
nslookup example.com
```

Using dig:

```bash
dig example.com
```

Verify:

- Correct IP address
- Expected TTL
- Successful name resolution

---

# Step 4 – Validate Application Access

Verify that the application is reachable using the configured domain name.

Confirm:

- DNS resolves successfully
- Load Balancer responds
- HTTPS certificate is valid

---

# Common Issues

## DNS Resolution Failure

Possible causes:

- Incorrect record
- Deleted record
- Wrong Hosted Zone
- Propagation delay

Verify:

```bash
nslookup example.com
```

---

## Incorrect IP Address

Possible causes:

- Wrong A Record
- Incorrect Alias target
- Load Balancer replacement

Verify current record values.

---

## High DNS Propagation Time

Review:

- TTL settings
- Recently updated records

Allow sufficient propagation time after changes.

---

## Hosted Zone Misconfiguration

Verify:

- Correct domain
- Correct Name Servers
- Registrar configuration

---

# Record Management

When updating DNS:

- Validate the change request.
- Review existing records.
- Apply the required change.
- Verify successful propagation.
- Confirm application accessibility.

---

# Best Practices

- Use Alias records for AWS resources where applicable.
- Keep TTL values appropriate for the environment.
- Review DNS changes before production deployment.
- Document all DNS modifications.
- Periodically audit hosted zones.

---

# Related Runbooks

- Application Deployment
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
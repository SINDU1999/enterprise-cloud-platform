# Amazon RDS Operations Runbook

## Purpose

This runbook provides operational procedures for managing Amazon RDS PostgreSQL databases used by the Enterprise Cloud Platform.

It covers health checks, monitoring, backups, maintenance, scaling, troubleshooting, and recovery.

---

# Scope

This runbook applies to all Amazon RDS PostgreSQL instances in:

- Development
- QA
- Production

---

# Prerequisites

Before performing database operations:

- AWS CLI configured
- IAM permissions for Amazon RDS
- Access to the AWS Console
- Database credentials available

---

# Step 1 – Verify Database Status

Using AWS CLI:

```bash
aws rds describe-db-instances
```

Verify:

- Status = available
- Correct instance class
- Storage allocation
- Availability Zone

---

# Step 2 – Monitor Database Health

Review:

- CPU Utilization
- Free Storage Space
- Freeable Memory
- Database Connections
- Read/Write Latency
- Disk Queue Depth

Monitor metrics using Amazon CloudWatch.

---

# Step 3 – Verify Connectivity

Check endpoint:

```bash
nslookup <rds-endpoint>
```

Test connectivity:

```bash
psql -h <rds-endpoint> -U <username> -d <database>
```

---

# Step 4 – Review Backups

Verify:

- Automated backups enabled
- Backup retention period
- Latest snapshot available

List snapshots:

```bash
aws rds describe-db-snapshots
```

---

# Step 5 – Maintenance

Review:

- Pending maintenance actions
- Engine version
- Minor version upgrades
- Parameter group updates

Schedule maintenance during approved windows.

---

# Common Issues

## Database Unavailable

Possible causes:

- Maintenance activity
- Instance restart
- Network issues
- Security Group configuration

Verify instance status and connectivity.

---

## High CPU Utilization

Possible causes:

- Long-running queries
- Missing indexes
- Increased workload

Review active queries and CloudWatch metrics.

---

## Storage Full

Symptoms:

- Write failures
- Performance degradation

Review Free Storage Space and increase allocated storage if required.

---

## Connection Failures

Verify:

- Security Groups
- VPC configuration
- Database endpoint
- Database credentials

---

# Backup and Restore

Create a manual snapshot:

```bash
aws rds create-db-snapshot \
  --db-instance-identifier <db-instance> \
  --db-snapshot-identifier manual-backup
```

Restore from a snapshot when necessary using the AWS Console or AWS CLI.

---

# Best Practices

- Enable automated backups.
- Monitor CloudWatch alarms.
- Perform regular maintenance.
- Review database performance periodically.
- Test restore procedures.
- Restrict database access using IAM and Security Groups.

---

# Related Runbooks

- Backup & Restore
- CloudWatch Monitoring
- Incident Response

---

# Document Version

Version: 1.0

Status: Active
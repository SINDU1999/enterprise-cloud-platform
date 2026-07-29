# Networking Design

## Overview

This document describes the networking architecture of the Enterprise Cloud Platform deployed on AWS.

The networking layer provides secure communication between infrastructure components while following AWS networking best practices.

---

# Objectives

The networking architecture is designed to provide:

- Secure communication
- High availability
- Network isolation
- Controlled internet access
- Scalable infrastructure

---

# Network Components

The platform uses the following AWS networking services:

- Amazon VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- Route 53
- Elastic Network Interfaces (ENIs)

---

# High-Level Network Layout

```
                    Internet
                        │
                Internet Gateway
                        │
                 Amazon VPC
      ┌─────────────────┴─────────────────┐
      │                                   │
Public Subnets                     Private Subnets
      │                                   │
 Load Balancer                   Amazon EKS Nodes
                                      │
                                      ▼
                               Application Pods
                                      │
                                      ▼
                           Amazon RDS PostgreSQL
```

---

# Virtual Private Cloud (VPC)

The Amazon VPC provides an isolated networking environment for all platform resources.

It includes:

- CIDR block
- Public subnets
- Private subnets
- Route tables
- Security Groups

---

# Public Subnets

Public subnets host internet-facing resources such as:

- Application Load Balancer
- Bastion host (if required)

These subnets have routes to the Internet Gateway.

---

# Private Subnets

Private subnets host internal resources including:

- Amazon EKS worker nodes
- Amazon RDS PostgreSQL
- Internal application services

These resources are not directly accessible from the internet.

---

# Route Tables

Route tables control network traffic between:

- Public subnets
- Private subnets
- Internet Gateway
- Internal AWS resources

Each subnet is associated with the appropriate route table.

---

# Security Groups

Security Groups act as virtual firewalls.

Rules are configured to allow only required traffic between:

- Load Balancer
- Amazon EKS
- Amazon RDS
- Administrative access

The principle of least privilege is followed.

---

# DNS

Amazon Route 53 provides DNS services for the platform.

It manages:

- Hosted Zones
- A Records
- Alias Records
- CNAME Records

DNS changes should be validated before deployment.

---

# Connectivity Validation

Useful commands:

```bash
kubectl get svc
kubectl get ingress

nslookup example.com
dig example.com
```

---

# Best Practices

- Use private subnets for backend resources.
- Limit inbound access through Security Groups.
- Keep Route Tables simple and well documented.
- Review DNS records before production changes.
- Regularly audit networking configuration.

---

# Related Documents

- architecture.md
- deployment-guide.md
- security.md

---

# Document Version

Version: 1.0

Status: Active
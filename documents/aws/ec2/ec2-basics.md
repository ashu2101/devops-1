🖥️ AWS EC2 (Elastic Compute Cloud) - Complete Guide

📌 Overview

Amazon EC2 (Elastic Compute Cloud) provides scalable compute capacity in the AWS cloud. It eliminates the need to invest in hardware upfront, so you can develop and deploy applications faster.

Use cases include:

Web and app servers

High-performance computing

Batch processing

Dev/test environments

🧱 Core Concepts

1. Instances

Virtual servers for running applications

Created from AMIs (Amazon Machine Images)

Instance types define CPU, memory, storage, and network capacity

2. AMI (Amazon Machine Image)

Preconfigured template used to launch an instance

Includes OS, application server, and applications

Can use AWS-provided, Marketplace, or custom AMIs

3. Instance Types

Determines the hardware of the host computer

Categories:

General Purpose (t3, t4g, m5)

Compute Optimized (c6g, c5)

Memory Optimized (r6g, x2idn)

Storage Optimized (i4i, d3en)

Accelerated Computing (p4, inf2)

4. Key Pairs

Used for SSH access to Linux/Unix instances

Consists of a public key (stored by AWS) and private key (downloaded by user)

5. Security Groups

Virtual firewall that controls traffic to instances

You define inbound and outbound rules (e.g., allow port 22, 80)

6. Elastic IP Address

Static IPv4 address for dynamic cloud computing

Can be remapped to another instance

7. Elastic Block Store (EBS)

Persistent block-level storage

Can be attached/detached to/from EC2 instances

Types include gp3 (general purpose), io2 (provisioned IOPS), sc1 (cold HDD)

🛠️ Services in EC2 Dashboard

The EC2 dashboard in the AWS Management Console provides access to:

1. Instances

List and manage all EC2 instances

Launch, stop, start, reboot, or terminate instances

2. Launch Templates

Save instance configuration for future launches

Supports automation and auto scaling

3. Auto Scaling Groups

Maintain application availability and scale EC2 capacity up/down automatically

Works with Launch Templates and CloudWatch

4. Elastic Block Store (EBS)

View, create, and manage volumes and snapshots

Snapshots can be used for backups and AMI creation

5. Key Pairs

Manage public/private key pairs for secure login

6. Security Groups

Manage firewall rules

7. Load Balancers (linked to EC2 through EC2 Dashboard)

Distribute incoming traffic across instances

Use Classic Load Balancer, ALB, or NLB

8. Placement Groups

Logical grouping of instances within a single AZ for performance

Strategies: Cluster, Spread, Partition

9. Capacity Reservations

Reserve capacity in a specific AZ for future use

10. Dedicated Hosts and Instances

Physical servers allocated for your use to meet compliance requirements

11. Savings Plans and Reserved Instances

Cost-saving options for predictable workloads

🧩 Networking and Access

1. VPC (Virtual Private Cloud)

Logical isolation in the cloud

Contains subnets, route tables, gateways, etc.

2. Subnets

Range of IP addresses in your VPC

Public or private

3. Route Tables & Internet Gateway

Define how traffic is routed within the VPC

Required for internet access from public subnets

4. NAT Gateway / Instance

Allow outbound internet access for instances in private subnets

🛡️ Security and Monitoring

1. CloudWatch

Monitor CPU, disk, network utilization

Create alarms for usage thresholds

2. CloudTrail

Record API activity for auditing

3. SSM (Systems Manager)

Manage EC2 instances securely without SSH

Automate patching, run commands, and inventory

📥 EC2 Pricing Options

1. On-Demand Instances

Pay by the hour/second

No commitment

2. Reserved Instances

1-year or 3-year commitment

Up to 75% savings

3. Spot Instances

Bid for unused capacity

Up to 90% cost savings

Can be interrupted by AWS

4. Savings Plans

Commit to consistent usage (e.g., $10/hour for EC2)

Flexible across instance types and regions

📚 Summary

Amazon EC2 provides flexible and scalable compute capacity with full control over the instances. Whether it's a basic web server or a high-performance compute workload, EC2 supports a wide range of configurations, cost models, and integrations with other AWS services.

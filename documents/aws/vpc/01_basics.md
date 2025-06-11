# 🌐 AWS Networking Basics – Deep‑Dive Guide

> **Goal:** Provide a *from‑first‑principles* explanation of networking fundamentals and show how they map to AWS constructs such as **VPC**, **subnets**, **route tables**, **IGW**, **NAT**, **PrivateLink**, etc.  Diagrams (ASCII) are sprinkled throughout to visualise packet flow.

---

## 1 How Machines Talk – IP Fundamentals

### 1.1 IP Addressing & Subnetting

* **IPv4 address** = 32‑bit number written as *dotted‑decimal* (`192.168.1.10`).
* **Network portion vs host portion** determined by the *subnet mask* (`/24` = 255.255.255.0 → first 24 bits network).
* **CIDR (Classless Inter‑Domain Routing)** lets us write ranges compactly: `10.0.0.0/16` = 65 536 addresses.

### 1.2 Local vs Remote Delivery

When host `10.0.1.15/24` sends a packet to `10.0.1.20`:

1. **Mask & compare:** Destination is in same `/24`, so *local*.
2. **ARP lookup** → get target MAC.
3. Frame is delivered on L2 switch.

If destination is **outside** subnet, host forwards to **default gateway** (usually the router’s IP in same subnet).

### 1.3 Routing Table Primitives

| Route Destination | Meaning                                                 |
| ----------------- | ------------------------------------------------------- |
| `10.0.0.0/16`     | Send traffic to attached interface if in VPC CIDR.      |
| `local`           | Special entry for the subnet itself – stay on‑link.     |
| `0.0.0.0/0`       | The *default route* – “all other IPs” (i.e., Internet). |

> 🔎 **Remember:** Routing is longest‑prefix match; `10.0.0.0/16` beats `0.0.0.0/0`.

---

## 2 AWS VPC Building Blocks

| Construct                  | Purpose                           | Typical CIDR Example         |
| -------------------------- | --------------------------------- | ---------------------------- |
| **VPC**                    | Private virtual network           | `10.0.0.0/16`                |
| **Subnet (public)**        | Hosts with route to IGW           | `10.0.1.0/24`                |
| **Subnet (private)**       | No IGW, private traffic only      | `10.0.2.0/24`                |
| **Route Table**            | Defines where packets go          | Assoc. to subnets            |
| **Internet Gateway (IGW)** | Horizontally‑scaled edge router   | N/A                          |
| **NAT Gateway**            | Egress for private subnets        | Elastic IP attached          |
| **Security Group**         | Stateful firewall on ENI          | Inbound 80/443               |
| **NACL**                   | Stateless subnet firewall         | 0‑65535/0 TCP                |
| **VPC Endpoint**           | Private link to AWS service       | `com.amazonaws.us‑east‑1.s3` |
| **PrivateLink**            | Expose **your** service privately | VPCE DNS                     |

---

## 3 Flow #1 – Internet‑Bound EC2 in Public Subnet

```
┌────────────┐        IGW (Elastic, HA)         ┌───────────────┐
│ EC2 10.0.1.5│ → route table 0.0.0.0/0 → ════► │   Internet    │
└────────────┘                                 └───────────────┘
(subnet 10.0.1.0/24)  (VPC 10.0.0.0/16)
```

Steps:

1. EC2 sees dest not in `10.0.1.0/24` → uses the VPC route table.
2. Longest match = `0.0.0.0/0` target **igw‑id**.
3. IGW performs NAT: private IP ↔ public Elastic IP.

---

## 4 Flow #2 – Private Subnet ➜ NAT ➜ Internet

```
┌──────────────┐    10.0.2.0/24        ┌────────────┐
│ EC2 10.0.2.8 │ ────────────────►     │ NAT Gateway│ ──► IGW ──► Internet
└──────────────┘    route 0.0.0.0/0    └────────────┘
```

* NAT GW lives in *public* subnet, has Elastic IP.
* Outbound only; inbound is dropped unless part of an existing flow.

---

## 5 Flow #3 – PrivateLink to Internal Service

```
Producer VPC             Consumer VPC
┌────────────┐          ┌────────────┐
│ NLB + ENI  │◄──AZ ENIs│   EC2      │
└────────────┘          └────────────┘
      ▲                        │
      │ PrivateLink            │  https://service.vpce-123.aws
      └────────────────────────┘
```

* **Interface VPC Endpoint** in consumer VPC gets private IPs and DNS.
* Traffic stays on AWS backbone – no IGW/NAT.

---

## 6 Advanced Routing Constructs

### 6.1 VPC Peering vs Transit Gateway (TGW)

* **VPC Peering**: point‑to‑point, transitive *not* allowed.
* **TGW**: Hub‐and‐spoke, transitive routing, up to 5k attachments.

### 6.2 Route 53 Resolver Endpoints

Inbound/outbound DNS forwarding between on‑prem and VPC.

---

## 7 Security Controls Checklist

| Layer  | AWS Feature      | Notes                   |
| ------ | ---------------- | ----------------------- |
| Subnet | Network ACLs     | Stateless allow/deny    |
| ENI    | Security Groups  | Stateful; recommended   |
| Edge   | AWS WAF / Shield | L7 / L3‑4 DDOS          |
| VPC    | Flow Logs        | Visibility into traffic |

---

## 8 Key CIDR & Route Table Rules

* **`local`** route is automatically added: `VPC‑CIDR → local` – enables intra‑VPC traffic.
* **`0.0.0.0/0`** means *match anything not matched earlier* – default to Internet/NAT/TGW.
* Prefix specificity: `/32` (single IP) > `/24` > `/0`.

---

## 9 Common Pitfalls & Tips

1. **Overlapping CIDRs** break VPC peering – plan IP ranges early.
2. Propagate **TGW routes** to route tables or add static ones.
3. NACL order matters; rules evaluated top‑down.
4. For on‑prem IPSec, use **VGW** or **Direct Connect Gateway**.

---

## 10 Learning Resources

* AWS VPC User Guide: [https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* AWS Networking Blog: [https://aws.amazon.com/blogs/networking-and-content-delivery/](https://aws.amazon.com/blogs/networking-and-content-delivery/)
* **Hands‑on labs:** AWS Skill Builder → “Architecting on AWS – VPC Connectivity”

---

### 📌 Cheat‑Sheet Summary

| Topic                       | Key Takeaway                                |
| --------------------------- | ------------------------------------------- |
| Public vs Private Subnet    | Route to IGW present or not                 |
| NAT GW vs IGW               | NAT = outbound only; IGW = bidirectional    |
| PrivateLink vs Endpoint Svc | One‑to‑many SaaS, stays private             |
| `0.0.0.0/0`                 | Default route / Internet catch‑all          |
| `local`                     | Intra‑VPC traffic never leaves AWS backbone |

---

**End of Guide – you now have a solid mental model of AWS networking flows and core concepts.**

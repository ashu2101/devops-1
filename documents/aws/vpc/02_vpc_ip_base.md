# 🛠️ AWS VPC & CIDR Planning – Deep‑Dive Guide

---

## 1 What is an Amazon VPC?

A **Virtual Private Cloud (VPC)** is an isolated, logically‑defined network within AWS where you launch resources (EC2, RDS, Lambda ENIs, etc.). It resembles a traditional on‑prem data‑center network but is fully software‑defined.

> *Analogy*: Think of a VPC as your company’s fenced campus; subnets are the buildings inside, and route tables are the road signs telling traffic where to go.

| VPC Attribute        | Default Limit (IPv4) | Notes                             |
| -------------------- | -------------------- | --------------------------------- |
| CIDR blocks per VPC  | 5 (can be increased) | Each block up to /16 in size      |
| IPv4 addresses / VPC | Depends on CIDR size | /16 ⇒ 65 536‑5 usable = 65 531    |
| IPv6 block           | /56 per VPC          | 256 /64 subnets                   |
| Subnets per VPC      | 200 (soft limit)     | Hard limit 400 – request increase |

---

## 2 IP Addressing & CIDR Refresher

### 2.1 CIDR Notation

`10.0.0.0/16` means the **first 16 bits** are the network portion → leaves **16 bits for hosts** (2¹⁶ = 65 536 addresses).

> **Rule of thumb**: Smaller suffix → larger network ( `/16` > `/20` ).

| Prefix | Hosts (usable) |
| ------ | -------------- |
| /24    | 256‑5 ≈ 251    |
| /20    | 4,096‑5        |
| /16    | 65,536‑5       |

### 2.2 Reserved Addresses Inside Each Subnet

AWS keeps 5:

1. Network address    (`.0`)
2. VPC router         (`.1`)
3. DNS/META           (`.2`)
4. Future use         (`.3`)
5. Broadcast          (`.255` for /24)

---

## 3 Choosing the **VPC CIDR Block**

> **Golden rule** – Plan **big enough** for 5‑year growth yet **small enough** to avoid overlap with existing corporate ranges.

### 3.1 RFC 1918 Private Ranges

| Range          | Size       | Typical Use       | Comment                    |
| -------------- | ---------- | ----------------- | -------------------------- |
| 10.0.0.0/8     | 16 777 216 | Enterprise clouds | “Safe” default in AWS docs |
| 172.16.0.0/12  | 1 048 576  | Branch offices    | Less contention than 10/8  |
| 192.168.0.0/16 | 65 536     | Home/Lab networks | Avoid if VPN users at home |

### 3.2 Sizing Formula

```
Expected hosts × 1.3 (buffer) → nearest power‑of‑two ≥ result → /mask
```

Example: 10 000 hosts → 13 000 buffer → needs 14 bits host ⇒ `/18` (16 382 hosts).

### 3.3 Overlap Constraints

* **VPC Peering / TGW / VPN / Direct Connect** require **non‑overlapping CIDRs**.
* Plan per‑region ranges: e.g.

  * `10.0.0.0/16` – us‑east‑1
  * `10.1.0.0/16` – us‑west‑2

### 3.4 Multi‑CIDR Feature

Since 2020 you can **add** secondary CIDR blocks to a VPC (no downtime) – handy for future expansion.

---

## 4 Designing Subnets

### 4.1 AZ‑Aligned Pattern

```
VPC 10.0.0.0/16
├── Public‑a  10.0.0.0/24
├── Private‑a 10.0.1.0/24
├── Public‑b  10.0.2.0/24
└── Private‑b 10.0.3.0/24
```

* **Public subnet**: Route `0.0.0.0/0 → igw‑id`.
* **Private subnet**: Route `0.0.0.0/0 → nat‑gw‑id`.

> **Tip**: Keep subnet masks consistent (/24) for simplicity; IPv6 always /64.

### 4.2 Small vs Large Subnets

* **/28** minimum size (11 usable IPs) – fine for NAT/Bastion.
* **/19** maximum in one AZ (8192 hosts) – else split.

### 4.3 Dual‑stack (IPv6)

* Allocate `/56` → each subnet gets a `/64`.
* IPv6 egress doesn’t need NAT – IGW handles it.

---

## 5 Route Tables & Flow Examples

### 5.1 Basic Public Subnet Route Table

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |
| 0.0.0.0/0   | igw‑id |

### 5.2 NAT Flow Diagram

```
EC2 10.0.1.15 (private)
   │  dst=52.95.x.x
   ▼
route table → target nat‑gw‑id (in 10.0.0.0/24 public)
   ▼
NAT GW translates src 10.0.1.15 → Elastic IP 3.3.3.3
   ▼
IGW → Internet
```

---

## 6 Practical CIDR Planning Workflow

1. **Inventory** on‑prem & other VPCs CIDRs.
2. Pick an unused /8 or /12 parent block.
3. Carve **/16 per region**.
4. Carve **/24 per AZ × subnet‑type**.
5. Document in a spreadsheet + IPAM.
6. Reserve future blocks for TGW attachments & PrivateLink.

---

## 7 Tools & Calculators

* **AWS VPC CIDR Wizard** (console) shows conflicts.
* Open‑source IPAM: netbox, phpIPAM.
* Online CIDR calculator: [https://www.ipaddressguide.com/cidr](https://www.ipaddressguide.com/cidr)

---

## 8 Best‑Practice Checklist

✔ Use RFC1918 ranges only (unless IPv6‑only workloads).
✔ Avoid 10.0.0.0/8 overlap with other business units by using `/16` partitioning.
✔ Split workloads (public web, app, data) into separate subnets + SGs.
✔ Enable VPC Flow Logs for audit.
✔ Tag subnets (`Network=Public/Private`, `AZ=us‑east‑1a`).
✔ Plan for Multi‑CIDR and IPv6 from day‑one.

---

### 📚 Further Reading

* VPC User Guide: [https://docs.aws.amazon.com/vpc/latest/userguide/](https://docs.aws.amazon.com/vpc/latest/userguide/)
* CIDR Expansion: [https://aws.amazon.com/blogs/networking-and-content-delivery/expanding-your-vpc-cidr-block/](https://aws.amazon.com/blogs/networking-and-content-delivery/expanding-your-vpc-cidr-block/)
* IPv6 in VPC: [https://docs.aws.amazon.com/vpc/latest/userguide/ipv6-working-with-ipv6.html](https://docs.aws.amazon.com/vpc/latest/userguide/ipv6-working-with-ipv6.html)

---

**End of Document – You should now have a solid understanding of AWS VPC CIDR design, subnetting, and routing.**

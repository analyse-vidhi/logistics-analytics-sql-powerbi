# Logistics Operations & Customer Analytics (SQL + Power BI)

An end-to-end analytics project built on a relational logistics dataset to monitor delivery performance, payment behavior, customer value, and employee workload. The project combines advanced SQL analysis (CTEs, window functions, KPI logic) with an interactive Power BI dashboard for decision-ready reporting.

---

## Business Objectives

This project answers practical logistics questions such as:
- Which shipments are **delayed** or **not delivered** and by how many days?
- Which customers contribute the most to **revenue**, within each customer segment?
- How do **payment modes** (COD vs Card) and **payment status** impact performance metrics?
- Which employees handle **above-average shipment volumes**?

---

## Dataset Overview

- **Size:** ~250 rows per table (small but relational and analytical)
- **Structure:** **10 tables**, ~**10–11 columns** per table
- **Domain:** Logistics operations covering customers, shipments, status tracking, payments, and employee handling

### Key Entities (high level)
- Customers & Memberships
- Shipments (domain, service type, weight, charges, addresses)
- Shipment Status (sent date, delivery date, current status)
- Payments (amount, mode, status, date)
- Employee details + employee–shipment relationship mapping

> ERD / schema diagram: see `schema.png` (recommended)  
> Data files: see `data/` folder

---

## Tech Stack

- **SQL:** MySQL (joins, aggregations, `HAVING`, CTEs, window functions)
- **BI:** Power BI (data modeling, DAX measures where required, interactive visuals)
- **Connectivity:** MySQL → Power BI via **ODBC (64-bit)**

---

## Key Analytics & KPIs

### 1) Delivery Performance
- Delivery delay in days: `Delivery_Date - Sent_Date`
- Delayed shipment flag (SLA-based threshold)
- Current backlog: shipments **Not Delivered** beyond SLA

### 2) Customer Value
- Total revenue contribution per customer
- Rank customers **within each Customer_Type** (window functions)
- Customers with above-average payment behavior

### 3) Payment Insights
- Payment mode and payment status distribution
- Average payment amount by mode/type (with null-date handling)

### 4) Workforce / Operations
- Shipment workload per employee
- Employees handling above-average shipment volumes

---
## Repository Structure

logistics-sql-powerbi/
├─ README.md
├─ sql/
│ ├─ 01_create_schema.sql
│ ├─ 02_load_data.sql
│ ├─ 03_analysis_queries.sql
│ ├─ 04_views.sql
├─ data/
│ ├─ Customer.csv
│ ├─ Employee_Details.csv
│ ├─ employee_manages_shipment.csv
│ ├─ Membership.csv
│ ├─ Payment_Details.csv
│ ├─ Shipment_Details.csv
│ ├─ Status.csv
│ └─ ...
├─ powerbi/
│ ├─ Logistics_Dashboard.pbix
│ └─ dashboard_screenshots/
└─ model_relationships.png


---

## How to Run This Project (Reproducible Setup)

### Step 1 — Load data into MySQL
1. Create a new database (example: `logistics_db`)
2. Run:
   - `sql/01_create_schema.sql`
3. Import CSVs from the `data/` folder into respective tables  
   (MySQL Workbench: Table → Import Wizard)

> Optional: If provided, run `sql/02_load_data.sql` for scripted imports.

---

### Step 2 — Run SQL analysis
- Execute queries from:
  - `logistics_queries.sql`

---

### Step 3 — Connect Power BI to MySQL (ODBC)
1. Install **MySQL ODBC Driver (64-bit)**
2. Create a **System DSN** (recommended) pointing to:
   - Server: `localhost`
   - Port: `3306`
3. Power BI → **Get Data → ODBC** → select DSN → load tables

> Note: If dates are stored as text in `MM/DD/YYYY`, convert using **Change Type → Using Locale** in Power Query.

---

## Dashboard Preview

Screenshots are available in: `powerbi/dashboard_screenshots/`

Typical dashboard sections:
- **Overview:** shipment volume, payment mix, delivery status
- **Delays:** delayed shipments, delay distribution, backlog
- **Customer Value:** revenue contribution, segment ranking, payment patterns

---

## Data Quality Checks Included

Examples of checks implemented:
- Null checks on critical dates and identifiers
- Duplicate detection (e.g., multiple payments per shipment)
- Relationship validation (customer ↔ shipment ↔ status ↔ payment)

---

## Project Highlights 

- Built an end-to-end analytics workflow: **SQL → Data Modeling → BI Dashboard**
- Applied **CTEs and window functions** for ranking and benchmarking
- Developed **operational KPIs** (delivery delay, backlog, SLA flags)
- Delivered a clean, interactive dashboard supporting business decisions 
## Repository Structure


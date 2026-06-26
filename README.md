# ShopSphere: End-to-End Analytics Engineering Project (BigQuery, dbt & Looker Studio)

## Executive Summary

ShopSphere is an end-to-end Analytics Engineering project simulating a modern e-commerce company.

The objective of this project was to design and implement a complete analytics stack capable of transforming raw operational and marketing data into business-ready insights for decision-makers.

The project covers the entire analytics lifecycle:

- Data generation using Python
- Cloud data warehouse implementation in BigQuery
- Data transformation using dbt
- Dimensional modeling (Star Schema)
- Customer 360 development
- Reporting-focused One Big Table (OBT)
- Executive dashboard development in Looker Studio
- Data governance and security considerations

The final solution enables stakeholders to monitor revenue growth, profitability, customer acquisition efficiency, customer lifetime value, and retention through an interactive dashboard.

---

## Business Context

ShopSphere is a fictional e-commerce retailer operating across multiple countries and acquisition channels.

The leadership team requires visibility into key business questions such as:

- Is the business growing profitably?
- Which marketing channels generate the best return?
- How much does it cost to acquire a customer?
- What is the average customer lifetime value?
- Are customers being retained effectively?
- Which countries contribute the most revenue?

The goal of this project is to build a scalable analytics platform capable of answering these questions while following modern Analytics Engineering best practices.

---

## Tech Stack

| Layer | Technology |
|---------|---------|
| Data Generation | Python |
| Data Warehouse | Google BigQuery |
| Transformation Layer | dbt Cloud |
| Data Modeling | SQL |
| Visualization | Looker Studio |
| Version Control | GitHub |

---

## Architecture

![Architecture Diagram](architecture/Architecture%20Diagram.png)

### Data Flow

```text
Python Data Generator
          ↓
BigQuery Raw Tables
          ↓
dbt Staging Layer
          ↓
dbt Intermediate Layer
          ↓
Fact & Dimension Models
          ↓
Analytics Layer
          ↓
Looker Studio Dashboard
```

---

## Warehouse Architecture

The warehouse follows a layered architecture designed to improve maintainability, scalability, and business logic reusability.

### Staging Layer

Purpose:

- Standardize source data
- Rename columns
- Cast data types
- Apply basic cleaning

Models:

```text
stg_customers
stg_orders
stg_products
stg_sessions
stg_marketing_spend
stg_refunds
stg_support_tickets
```

---

### Intermediate Layer

Purpose:

- Centralize reusable business logic
- Avoid duplicated calculations across models

Models:

```text
int_customer_metrics
int_order_profit
int_marketing_daily
```

---

### Marts Layer

Purpose:

- Create business-facing fact and dimension models
- Implement dimensional modeling

Dimension Models:

```text
dim_customers
dim_products
```

Fact Models:

```text
fct_orders
fct_sessions
fct_refunds
fct_support_tickets
fct_marketing_spend
fct_marketing_performance
fct_customer_acquisition
```

---

### Analytics Layer

Purpose:

- Provide reporting-ready semantic models

Models:

```text
customer_360
obt_shopsphere_performance
```

---

## Dimensional Modeling

The warehouse follows a Star Schema design.

### Fact Tables

| Table | Description |
|---------|---------|
| fct_orders | Order transactions |
| fct_sessions | Website sessions |
| fct_marketing_spend | Marketing spend by channel |
| fct_marketing_performance | Revenue and spend at common grain |
| fct_customer_acquisition | Customer acquisition metrics |
| fct_refunds | Refund transactions |

### Dimension Tables

| Table | Description |
|---------|---------|
| dim_customers | Customer master data and behavioral metrics |
| dim_products | Product attributes and categorization |

---

## dbt Lineage

![dbt Lineage](architecture/DAG%20Lineage%20-%20customer_360.png)
![dbt Lineage](architecture/DAG%20Lineage%20-%20obt_shopsphere_performance.png)

The lineage graph demonstrates the flow of data from raw source tables through staging, intermediate transformations, marts, and analytics models.

---

## Customer 360

One of the key deliverables of the project is the Customer 360 model.

This model consolidates customer information from multiple sources into a single business-facing table.

### Included Metrics

- First Order Date
- Most Recent Order Date
- Number of Orders
- Lifetime Revenue
- Lifetime Profit
- Total Sessions
- Converted Sessions
- Support Tickets
- Customer Age
- Customer Status (Active / Churned)

This model enables customer-level analysis and powers retention and lifetime value reporting.

---

## Reporting Layer (OBT)

To simplify dashboard development and improve reporting performance, a reporting-focused One Big Table (OBT) was created.

### Purpose

Provide a single source for business KPI calculations.

### Included Metrics

- Revenue
- Cost
- Profit
- Orders
- Purchasing Customers
- Marketing Spend
- New Customers
- Sessions
- Converted Sessions
- Refunds
- Refunded Amount

### Grain

```text
Date
+
Country
+
Channel
```

The OBT allows KPI calculations to be performed directly in Looker Studio while preserving dimensional flexibility.

---

## Data Quality

The project follows dbt data quality best practices.

Implemented validations include:

- Primary Key Uniqueness
- Not Null Tests
- Referential Integrity Tests
- Accepted Values Tests

Examples:

- Customer IDs must be unique
- Orders must reference valid customers
- Revenue values cannot be null
- Customer statuses must contain accepted values only

---

## Core Business Metrics

| Metric | Description |
|---------|---------|
| Revenue | Total sales generated |
| Profit | Revenue minus cost |
| Orders | Total completed orders |
| AOV | Average Order Value |
| Marketing Spend | Advertising investment |
| ROI | Return on Investment |
| ROAS | Return on Advertising Spend |
| CAC | Customer Acquisition Cost |
| Conversion Rate | Converted Sessions / Total Sessions |
| CLTV | Customer Lifetime Value |
| CLTV:CAC Ratio | Customer value relative to acquisition cost |
| Churn Rate | Percentage of churned customers |
| Refund Rate | Refunded Orders / Total Orders |

---

## Dashboard

### Executive Overview

![Executive Overview](dashboard/Executive%20Overview.png)

Key KPIs:

- Revenue
- Profit
- Orders
- Purchasing Customers
- Average Order Value
- Profit Margin

Business Question:

> Is the business growing profitably?

---

### Marketing Performance

![Marketing Performance](dashboard/Marketing%20Performance.png)

Key KPIs:

- Marketing Spend
- New Customers
- CAC
- ROI
- ROAS
- Cost per Order

Business Question:

> Are marketing investments generating efficient customer acquisition?

---

### Customer Analytics

![Customer Analytics](dashboard/Customer%20Analytics.png)

Key KPIs:

- Active Customers
- Churn Rate
- Average CLTV
- Average Lifetime Profit
- Conversion Rate

Business Question:

> Are customers being retained and monetized effectively?

---

## Key Business Questions Answered

The project enables stakeholders to answer questions such as:

1. Is the business growing profitably?
2. Which acquisition channels generate the highest ROI?
3. How much does it cost to acquire a customer?
4. Which countries drive the most revenue?
5. What is the average customer lifetime value?
6. What percentage of customers churn?
7. Which channels deliver the highest-value customers?
8. How effectively does website traffic convert into purchases?

---

## Data Governance & Security (RBAC)

To ensure data integrity and align with enterprise analytics standards, the warehouse architecture follows a layered access model.

### Restricted Layers

```text
shopsphere_staging
shopsphere_intermediate
```

Access is limited to:

- Analytics Engineering Team
- dbt Service Account

Business users are intentionally restricted from these layers to prevent dependencies on incomplete or unstable transformation logic.

### Business Layer

```text
shopsphere_analytics
```

This is the only client-facing layer.

Business users and BI tools receive read-only access, ensuring a governed and trusted Single Source of Truth (SSOT).

This approach follows the Principle of Least Privilege and reduces reporting risk.

---

## Production Considerations

For this project, permissions were configured manually using BigQuery IAM.

In a production environment, the architecture would typically be expanded with:

- Terraform-managed infrastructure
- Google Groups for access management
- CI/CD pipelines
- dbt Deployment Jobs
- Incremental Models
- Environment Separation (Dev / Prod)
- Automated Monitoring & Alerting

This ensures scalability, auditability, and infrastructure consistency.

---

## What This Project Demonstrates

This project showcases practical experience with:

- Analytics Engineering
- dbt Development
- Cloud Data Warehousing
- BigQuery
- SQL Data Modeling
- Star Schema Design
- Customer 360 Modeling
- Semantic Layer Development
- Business KPI Design
- Dashboard Development
- Data Governance Concepts
- Git-Based Analytics Workflows

---

## Lessons Learned

Throughout this project I practiced:

- Designing a layered warehouse architecture
- Building reusable transformation logic in dbt
- Modeling customer-centric analytics
- Creating reporting-ready semantic layers
- Developing executive dashboards
- Applying governance principles to analytics workflows
- Translating business requirements into analytical solutions

---

## Repository Structure

```text
shopsphere-analytics-engineering-project/

├── architecture/
├── dashboard/
├── data_generation/
├── models/
│   ├── staging/
│   ├── intermediate/
│   ├── marts/
│   └── analytics/
├── tests/
├── dbt_project.yml
├── packages.yml
└── README.md
```

---

## About the Author

**Raul Siqueira**

Senior Data Analyst with experience in Analytics, Business Intelligence, Experimentation, and Data Modeling.

Currently expanding expertise into Analytics Engineering, modern data stacks, cloud-based analytics architectures, and freelance data consulting.

**LinkedIn:** [Linkedin](https://www.linkedin.com/in/raul-siqueira/)

**GitHub:** [GitHub](https://github.com/raulsiqueira96)

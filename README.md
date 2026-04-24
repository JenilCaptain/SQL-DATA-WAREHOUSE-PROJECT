# 🚀 SQL Data Warehouse Project

![Project Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)
![Made By](https://img.shields.io/badge/Made%20By-Jenil%20Captain-blue?style=for-the-badge)
![Open To Work](https://img.shields.io/badge/Open%20to-Opportunities-orange?style=for-the-badge)

## 📌 Overview
This project demonstrates the design and implementation of an **end-to-end SQL Data Warehouse**, transforming raw data from multiple sources into structured, analytics-ready datasets.

The pipeline follows a **modern data warehousing approach (Bronze → Silver → Gold layers)** and integrates data from CRM and ERP systems to generate meaningful business insights.

---

## 🎯 Objectives
- Build a scalable **data warehouse architecture**
- Integrate and clean data from multiple sources
- Design a **star schema** for analytical queries
- Perform data transformation using advanced SQL
- Generate **business-ready reporting tables**

---

## 🏗️ Architecture

The project follows a **3-layer architecture**:

### 🥉 Bronze Layer (Raw Data)
- Stores raw data ingested from source systems (CRM & ERP)
- Minimal transformation
- Acts as a historical data backup

### 🥈 Silver Layer (Processed Data)
- Data cleaning and standardization
- Handling missing and inconsistent values
- Schema alignment across sources

### 🥇 Gold Layer (Analytics Layer)
- Business-ready datasets
- Star schema implementation:
  - `fact_sales`
  - `dim_customers`
  - `dim_products`
- Optimized for reporting and analytics

---

## 🗂️ Data Sources

### CRM System
- Customer information
- Product details
- Sales transactions

### ERP System
- Additional customer attributes (e.g., birthdate)
- Location and demographic data
- Product category information

---

## 📊 Data Modeling

Implemented a **Star Schema**:

### Fact Table:
- `fact_sales`

### Dimension Tables:
- `dim_customers`
- `dim_products`

This structure enables:
- Efficient querying
- Better performance
- Scalable analytics

---

## ⚙️ ETL Process

### Extraction
- Data loaded from CRM & ERP source files

### Transformation
- Data cleaning and validation
- Joins across multiple sources
- Handling null and inconsistent values
- Feature engineering (e.g., customer segmentation)

### Loading
- Data stored into respective layers:
  - Bronze → Silver → Gold

---

## 📈 Reporting Layer

Created analytical tables such as:

### `report_customers`
Includes:
- Customer segmentation (**VIP / New**)
- Age groups
- Recency analysis (last order date)
- Customer profiling metrics

👉 This layer converts raw data into **actionable business insights**

---

## 🛠️ Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge&logo=database&logoColor=white)
![Data Warehouse](https://img.shields.io/badge/Data%20Warehouse-FF6F00?style=for-the-badge&logo=databricks&logoColor=white)
![ETL Pipeline](https://img.shields.io/badge/ETL-Pipeline-blue?style=for-the-badge)
![Data Modeling](https://img.shields.io/badge/Data%20Modeling-Star%20Schema-green?style=for-the-badge)
![Analytics](https://img.shields.io/badge/Analytics-Insights-purple?style=for-the-badge)

- **SQL (PostgreSQL)**
- Data Warehousing Concepts
- ETL Pipeline Design
- Data Modeling (Star Schema)
- Advanced SQL:
  - Joins
  - CTEs
  - Window Functions
  - CASE Statements

---

## 📁 Project Structure

```bash
SQL-DATA-WAREHOUSE-PROJECT/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── scripts/
│   ├── bronze/
│   │   ├── bronze_data_ingestion.sql
│   │   ├── bronze_load.sql
│   │
│   ├── silver/
│   │   ├── creating_silverLayer.sql
│   │   ├── silver_load.sql
│   │   ├── silver_processed_data_ingestion.sql
│   │
│   ├── gold/
│   │   └── general_gold_layer.sql
│   │
│   ├── data-analytics/
│   │   ├── 01_database_exploration.sql
│   │   ├── 02_dimension_exploration.sql
│   │   ├── 03_date_range_exploration.sql
│   │   ├── 04_measures_exploration.sql
│   │   ├── 05_magnitude_analysis.sql
│   │   ├── 06_ranking_analysis.sql
│   │   ├── 07_change_over_time_analysis.sql
│   │   ├── 08_cumulative_analysis.sql
│   │   └── 09_performance_analysis.sql
│
├── tests/
│   ├── gold_quality_checks.sql
│   └── silver_quality_checks.sql
│
└── docs/
```

---

## 🔍 Key Features

- Multi-source data integration (CRM + ERP)
- Layered architecture (Bronze/Silver/Gold)
- Star schema design
- Advanced SQL transformations
- Analytical reporting layer
- Data quality validation scripts

---

## 🧠 Key Learnings

- Real-world **data engineering workflows**
- Importance of **data modeling**
- Writing efficient **SQL queries**
- Handling messy, real-world data
- Building **end-to-end pipelines**

---

## 🚀 Future Improvements

- Add scheduling (Airflow / cron jobs)
- Integrate cloud platforms (Azure / AWS)
- Build dashboards using Power BI / Tableau
- Implement incremental data loading

---

## 🤝 Connect

If you’re working on similar projects or have feedback, feel free to connect!

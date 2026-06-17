# Data Catalog: Gold Layer

## Overview
The Gold Layer acts as our business-readiness data tier, specifically optimized for business intelligence, analytics, and reporting. It relies on a classic star schema architecture featuring **dimension tables** (descriptive context) and **fact tables** (quantitative metrics).

---

### 1. **gold.dim_customers**
- **Purpose:** Centralizes comprehensive customer profiles by blending core identity data with demographic and regional attributes.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | The primary surrogate key used to uniquely identify individual customer records within this dimension. |
| customer_id      | INT           | The foundational internal ID assigned to each customer account.                               |
| customer_number  | NVARCHAR(50)  | A unique business-facing serial or tracking code identifying the customer.                    |
| first_name       | NVARCHAR(50)  | The given name of the customer.                                                               |
| last_name        | NVARCHAR(50)  | The surname or family name of the customer.                                                   |
| country          | NVARCHAR(50)  | The customer's country of residence (e.g., 'Australia').                                      |
| marital_status   | NVARCHAR(50)  | Current marital status of the individual (e.g., 'Married', 'Single').                         |
| gender           | NVARCHAR(50)  | Gender classification as reported by the customer (e.g., 'Male', 'Female', 'n/a').            |
| birthdate        | DATE          | The customer's date of birth, stored in YYYY-MM-DD format (e.g., 1971-10-06).                  |
| create_date      | DATE          | The original timestamp indicating when the customer was first registered in the database.     |

---

### 2. **gold.dim_products**
- **Purpose:** Functions as the master registry for all products, capturing retail categories, structural properties, and baseline pricing.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | The primary surrogate key utilized to uniquely track product records in this dimension.       |
| product_id          | INT           | The backend system identifier assigned to a specific product item.                            |
| product_number      | NVARCHAR(50)  | A structured SKU or alphanumeric code used for warehouse logistics and stock tracking.        |
| product_name        | NVARCHAR(50)  | The commercial title of the item, including distinguishing details like model, color, and size.|
| category_id         | NVARCHAR(50)  | A foreign key mapping the product to its high-level organizational tier.                      |
| category            | NVARCHAR(50)  | The primary macro-grouping for the item (e.g., Bikes, Components).                            |
| subcategory         | NVARCHAR(50)  | A secondary, more granular classification refining the product group.                        |
| maintenance_required| NVARCHAR(50)  | Flag indicating if the product demands routine servicing or support (e.g., 'Yes', 'No').      |
| cost                | INT           | The baseline wholesale cost or production expense for the item, represented as integers.       |
| product_line        | NVARCHAR(50)  | The marketing segment or target series the product falls under (e.g., Road, Mountain).        |
| start_date          | DATE          | The official calendar date when this item was introduced to the market.                        |

---

### 3. **gold.fact_sales**
- **Purpose:** Records core transactional events, aggregating sales volumes, financial outputs, and fulfillment timelines.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | The unique commercial reference string tied to a customer transaction (e.g., 'SO54496').      |
| product_key     | INT           | Surrogate key linking this transaction line item directly to the product catalog dimension.    |
| customer_key    | INT           | Surrogate key mapping the transaction directly to the corresponding customer profile.          |
| order_date      | DATE          | The exact day the customer finalized and placed the purchase order.                           |
| shipping_date   | DATE          | The date the package left the fulfillment center or warehouse en route to the customer.        |
| due_date        | DATE          | The deadline by which full payment for the order must be processed.                           |
| sales_amount    | INT           | Gross revenue generated by this specific line item, recorded in whole currency units (e.g., 25).|
| quantity        | INT           | Total units of the product purchased within this specific line item transaction (e.g., 1).    |
| price           | INT           | The standalone unit price applied to the product during this sale (e.g., 25).                 |

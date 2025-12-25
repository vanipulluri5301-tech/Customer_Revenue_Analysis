# Customer_Revenue_Analysis
Project Overview

This project analyzes customer purchase behavior and revenue patterns for a fictional retail business. Using SQL Server, the database captures customers, orders, and payments to answer key business questions, such as:

Who are the highest-value customers?

How does revenue vary by customer region?

Are repeat customers more valuable than one-time customers?

What percentage of orders experience payment failures?

The project demonstrates the use of joins, subqueries, and conditional logic to derive actionable business insights from transactional data.

Database Schema

The database consists of three normalized tables:

Customers
| Column | Data Type | Description |
|--------------|-----------|-------------|
| CustomerID | INT PK | Unique customer identifier |
| FirstName | VARCHAR | Customer first name |
| LastName | VARCHAR | Customer last name |
| Email | VARCHAR | Customer email (unique) |
| Region | VARCHAR | Customer geographic region |
| SignupDate | DATE | Account creation date |

Orders
| Column | Data Type | Description |
|--------------|-----------|-------------|
| OrderID | INT PK | Unique order identifier |
| CustomerID | INT FK | References Customers(CustomerID) |
| OrderDate | DATE | Date order was placed |
| OrderTotal | DECIMAL | Total order value |
| OrderStatus | VARCHAR | Status (Completed, Cancelled, etc.) |

Payments
| Column | Data Type | Description |
|--------------|-----------|-------------|
| PaymentID | INT PK | Unique payment identifier |
| OrderID | INT FK | References Orders(OrderID) |
| PaymentDate | DATE | Payment transaction date |
| PaymentAmount| DECIMAL | Amount paid |
| PaymentMethod| VARCHAR | Payment type (Credit Card, PayPal, etc.) |
| PaymentStatus| VARCHAR | Payment outcome (Success, Failed) |

Entity Relationships:
Customers (1) → Orders (M) → Payments (M)

Tools Used

SQL Server Management Studio (SSMS) – database design, queries, and testing

T-SQL – data querying, aggregation, and conditional logic

Optional: Excel or Power BI for visualization of query results

Key SQL Concepts Demonstrated

JOINs – combining data across multiple tables

Subqueries – aggregating revenue and customer metrics

CASE WHEN – segmenting customers based on revenue and order frequency

Aggregations – SUM(), COUNT(), AVG() for revenue and performance analysis

Filtering – WHERE clauses to focus on completed orders and successful payments

Business Insights

Using this dataset and SQL queries, the following insights were derived:

Customer Lifetime Value (CLV): Identified high-value, medium-value, and low-value customers based on total revenue.

Repeat vs One-Time Customers: Repeat customers generate higher average revenue than one-time buyers, emphasizing the importance of retention programs.

Regional Revenue Analysis: Certain regions consistently contribute more to overall revenue, informing marketing and sales focus.

Payment Performance: Payment failure rates are low, but tracking failed transactions helps improve revenue capture and customer experience.

Segmentation Opportunities: Customers can be segmented for targeted marketing campaigns, loyalty programs, and strategic upselling.

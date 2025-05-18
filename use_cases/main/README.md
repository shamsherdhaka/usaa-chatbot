# Main

## Overview
First example for a very simple chatbot that works on structured and unstructured data.

## Use Case Deployment
Execute this SQL Query to create and run the notebook in your account which will generate data and required services.
```sql
EXECUTE IMMEDIATE FROM @CORTEX_AGENTS_DEMO.PUBLIC.GITHUB_REPO_CORTEX_AGENTS_DEMO/branches/main/use_cases/main/_internal/setup.sql
  USING (BRANCH => 'main', EXECUTE_NOTEBOOKS => TRUE) DRY_RUN = FALSE;
```

## Structured Data & Use Cases
This repository contains a **fictional dataset** about Customer orders. The dataset is split into three core tables:

1. **Customer Orders**  
Mapping of Customers to orders.

2. **Orders**  
 Customer orders including Order Date, Product, Quantity, Status and Country.

3. **Products**  
Product information such as the price.

## Unstructured Data & Use Cases
As an example, this demo contains multiple annual reports from artificial companies.

## Example Questions
### Selected Services:
Make sure to select the following services for the questions to work:  
- **ANNUAL_REPORTS_SEARCH**
- **sales_orders.yaml**

### **Questions for Structured Data**
These queries operate on structured, tabular data sources.

| Question | Data Complexity | Query Complexity |
|----------|----------------|--------|
| What was the total order quantity per month with status shipped? | Single table, no Search Integration | 🟢 **Easy** |
| What was the total order quantity per month for United Kingdom with status shipped? | Single table, 1 Search Integration | 🟡 **Medium** |
| What was the order revenue per month for steel for my customer Delta? | 3 tables, 2 Search Integrations | 🔴 **Hard** |
| What was the order revenue per month for steel and aluminium for my customer Delta? | 3 tables, 2 Search Integrations with multiple values | 🔴 **Hard** |

### **Questions for Unstructured Data**  
These queries analyze text-based documents.

| Question | Data Complexity | Query Complexity |
|----------|----------------|--------|
| What were the latest AI innovations from Googol in 2024? | Single text chunk | 🟢 **Easy** |
| What was the net profit for Delta in 2024 and which people were part of the board? | Two chunks from one document | 🟡 **Medium** |
| What was the combined net profit for Googol and Delta in 2024 according to their annual reports? | Two chunks from two documents | 🔴 **Hard** |

# Big Data Solution for E-commerce

## Project Overview

This project aims to design and implement scalable data models for a global e-commerce company using SQL and NoSQL databases. The primary goal is to store and analyze large-scale data efficiently while ensuring optimal performance for analytical and transactional queries.

## Technologies Used

- **PostgreSQL** (Relational Database)
- **MongoDB** (NoSQL Document Database)
- **Neo4J** (Graph Database)
- **Python** (Data Cleaning & Analysis)

## Project Structure

```
├── scripts/
│   ├── clean_data.py  # Data cleaning script
│   ├── load_data_psql.sql  # PostgreSQL schema & data loading
│   ├── load_data_mongodb.js  # MongoDB data loading
│   ├── load_data_neo4j.cypher  # Neo4J data loading
│   ├── q1.sql  # SQL query for campaign analysis
│   ├── q2.js  # MongoDB query for recommendations
│   ├── q3.cypher  # Neo4J query for full-text search
├── report.docx  # Full project report
├── README.md  # Project documentation
```

## Data Analysis Tasks

1. **Campaign Effectiveness Analysis**: Determine whether marketing campaigns influenced customer purchases.
2. **Personalized Product Recommendations**: Identify top recommended products for users.
3. **Full-Text Product Search**: Retrieve products based on keyword searches.

## Benchmarking

- Performance testing conducted on PostgreSQL, MongoDB, and Neo4J.
- Execution times for queries recorded and compared.
- Results visualized in a report with statistical analysis.

## Challenges & Learnings

As a beginner in database management, this project was challenging but extremely valuable. I gained hands-on experience in SQL and NoSQL data modeling, query optimization, and benchmarking techniques. This assignment significantly improved my understanding of database systems and their real-world applications.

## How to Run

1. Ensure you have PostgreSQL, MongoDB, and Neo4J installed.
2. Run the data cleaning script:
   ```bash
   python scripts/clean_data.py
   ```
3. Load data into the databases:
   ```bash
   sudo psql -d ecommerce -f scripts/load_data_psql.sql
   sudo mongosh --file scripts/load_data_mongodb.js
   sudo cat scripts/load_data_neo4j.cypher | cypher-shell
   ```
4. Execute analysis queries from the `/scripts` folder.

## Author

# 🛒 Big Data Solution for E-commerce 🚀

## 📌 Project Overview
This project explores SQL and NoSQL data models for an e-commerce company. It includes data cleaning, schema design, data loading, analytical queries, and performance benchmarking for PostgreSQL, MongoDB, and Neo4J.

## 📂 Repository Structure
```
Assignment2/
├── 📁 output/  # Contains benchmark results, logs, and execution reports
├── 📷 screenshots/  # Screenshots of query execution results
├── 📜 scripts/  # All scripts related to data processing and queries
│   ├── 🧹 clean_data.py  # Data cleaning script
│   ├── 🗃️ load_data_psql.sql  # PostgreSQL schema & data loading
│   ├── 📦 load_data_mongodb.js  # MongoDB data loading
│   ├── 🔗 load_data_neo4j.cypher  # Neo4J data loading
│   ├── 📊 q1.sql  # SQL query for campaign analysis
│   ├── 🎯 q2.js  # MongoDB query for recommendations
│   ├── 🔍 q3.cypher  # Neo4J query for full-text search
├── 📑 report.docx  # Full project report
├── 📖 README.md  # Project documentation
```

## ⚙️ Installation & Setup
### 📌 Prerequisites
- 🐍 Python 3.x
- 🛢️ PostgreSQL
- 🍃 MongoDB
- 🔗 Neo4J
- 🔎 Hackolade
  

### 🛠️ Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/dadaxonEnigma/Big-Data-Course
   cd Assignment2
   ```
2. Setup and load data for each database:
   - **PostgreSQL**: `psql -d ecommerce -f scripts/load_data_psql.sql`
   - **MongoDB**: `mongosh --file scripts/load_data_mongodb.js`
   - **Neo4J**: `cat scripts/load_data_neo4j.cypher | cypher-shell`

## 🔎 Running Queries
Execute analytical queries:
- **📊 Campaign analysis**:
  - `psql -d ecommerce -f scripts/q1.sql`
  - `mongosh --file scripts/q1.js`
  - `cat scripts/q1.cypher | cypher-shell`
- **🎯 Product recommendations**:
  - `psql -d ecommerce -f scripts/q2.sql`
  - `mongosh --file scripts/q2.js`
  - `cat scripts/q2.cypher | cypher-shell`
- **🔍 Full-text search**:
  - `psql -d ecommerce -f scripts/q3.sql`
  - `mongosh --file scripts/q3.js`
  - `cat scripts/q3.cypher | cypher-shell`

## ⏱️ Benchmarking
To benchmark query performance, run:
```sh
hyperfine 'psql -d ecommerce -f scripts/q1.sql' 'mongosh --file scripts/q1.js' 'cat scripts/q1.cypher | cypher-shell'
```

## 📊 Results
- The analysis results, query execution times, and comparative performance charts are included in `report.docx`.
- Screenshots of results are stored in the `screenshots/` directory.

## 📖 Reference
This project was inspired by insights from the research paper:
**Serhat Uzunbayir, "Relational Database and NoSQL Inspections using MongoDB and Neo4j on a Big Data Application"**, IEEE Xplore. 
[Read the paper](https://ieeexplore.ieee.org/document/9919589)
- **🍃 [Data modeling in MongoDB](https://www.mongodb.com/resources/basics/databases/data-modeling)**:
- **🔗 [Data modeling in Neo4j](https://neo4j.com/docs/getting-started/data-modeling/guide-data-modeling/)**:
- **🔍 [Hackolade](https://hackolade.com/)**:
- **📖 [Dataset reference](https://www.kaggle.com/datasets/mkechinov/direct-messaging)**:
- **🛒 [REES46 Marketing Platform](https://rees46.com/)**:



## 🏁 Conclusion
This project demonstrates different database approaches for handling big data in an e-commerce setting. PostgreSQL provides strong transactional consistency, MongoDB offers flexible schema design, and Neo4J excels in relationship analysis.

---
## Author
Turgunboev Dadakhon 

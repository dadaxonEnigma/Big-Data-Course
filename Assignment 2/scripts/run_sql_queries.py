import psycopg2
import time
import statistics
from tabulate import tabulate
import os

DB_PARAMS = {
    "dbname": "ecommerce",
    "user": "postgres",
    "password": "root",
    "host": "localhost",
    "port": "5432"
}

SQL_SCRIPTS = ["q1.sql", "q2.sql", "q3.sql"]

HEADERS = [
    ['Campaign ID', 'Campaign Type', 'Channel', 'Total Count', 'Is Test', 'Position', 'Clients Reached', 'Purchases Made', 'Purchase Rate (%)'],
    ['User ID', 'Product ID', 'Interaction Count', 'Purchase Count'],  
    ['Product ID', 'Category Code', 'Brand', 'Price', 'Tsvector']  
]

OUTPUT_DIR = "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/output/"

if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def execute_sql_script(cursor, script_path, headers):
    with open(script_path, "r", encoding="utf-8") as file:
        sql_query = file.read()
        print(f"Executing {script_path}...\n")
        start_time = time.time()
        cursor.execute(sql_query)
        try:
            rows = cursor.fetchall()
            print(tabulate(rows, headers=headers, tablefmt="grid"))
        except psycopg2.ProgrammingError:
            print("Query executed successfully.\n")
        end_time = time.time()
        execution_time = end_time - start_time
        print(f"Execution time for {script_path}: {execution_time:.4f} seconds")
        return rows, execution_time

try:
    conn = psycopg2.connect(**DB_PARAMS)
    cursor = conn.cursor()

    all_execution_times = {script: [] for script in SQL_SCRIPTS}  
    all_rows = {script: [] for script in SQL_SCRIPTS}  

    for i, script in enumerate(SQL_SCRIPTS):
        print(f"Running {script} 5 times...\n")
        for run in range(5):  
            rows, execution_time = execute_sql_script(cursor, script, HEADERS[i])
            all_execution_times[script].append(execution_time)
            all_rows[script].append(rows)
            print("-" * 50)

    for script, times in all_execution_times.items():
        avg_time = sum(times) / len(times)
        stdev_time = statistics.stdev(times) if len(times) > 1 else 0
        print(f"\nFor script {script}:")
        print(f"Average execution time: {avg_time:.4f} seconds")
        print(f"Standard deviation: {stdev_time:.4f} seconds")

    for i, script in enumerate(SQL_SCRIPTS):
        output_file = os.path.join(OUTPUT_DIR, f"PSQL_{script.split('.')[0]}_result.txt")  
        all_results = all_rows[script][0]  

        avg_time = sum(all_execution_times[script]) / len(all_execution_times[script])
        stdev_time = statistics.stdev(all_execution_times[script]) if len(all_execution_times[script]) > 1 else 0

        with open(output_file, "w", encoding="utf-8") as out_file:
            out_file.write(tabulate(all_results, headers=HEADERS[i], tablefmt="grid"))
            out_file.write("\n\n")
            out_file.write(f"Average execution time: {avg_time:.4f} seconds\n")
            out_file.write(f"Standard deviation: {stdev_time:.4f} seconds\n")
        
        print(f"Results saved to {output_file}\n")

    conn.commit()
    cursor.close()
    conn.close()
    print("All queries executed successfully!")

except Exception as e:
    print(f"Error: {e}")

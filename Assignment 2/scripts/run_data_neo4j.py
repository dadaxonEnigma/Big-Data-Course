from neo4j import GraphDatabase
import time
import statistics
from tabulate import tabulate

uri = "bolt://localhost:7687"
username = "neo4j"
password = "password"

QUERY_FILES = [
    "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/scripts/q1.cypher",
    "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/scripts/q2.cypher",
    "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/scripts/q3.cypher"
]

def run_query_from_file(filename, driver):
    try:
        with open(filename, 'r', encoding="utf-8") as file:
            query = file.read()

        print(f"Executing query from: {filename}")

        times = []
        with driver.session() as session:
            for _ in range(5): 
                start_time = time.time()
                result = list(session.run(query)) 
                end_time = time.time()

                execution_time = end_time - start_time
                times.append(execution_time)

        avg_time = sum(times) / len(times)
        stdev_time = statistics.stdev(times) if len(times) > 1 else 0

        print(f"Results from {filename}:")
        if result:
            headers = result[0].keys()
            table = [list(doc.values()) for doc in result]
            print(tabulate(table, headers=headers, tablefmt="grid"))

        print(f"Execution times: {times}")
        print(f"Average execution time: {avg_time:.4f} seconds")
        print(f"Standard deviation: {stdev_time:.4f} seconds\n")
        return avg_time, stdev_time

    except Exception as e:
        print(f"Error executing query from file {filename}: {e}")
        return None, None

driver = GraphDatabase.driver(uri, auth=(username, password))

results = {filename: run_query_from_file(filename, driver) for filename in QUERY_FILES}

print("Benchmarking results summary:")
for filename, (avg, std) in results.items():
    if avg is not None:
        print(f"{filename}: Avg = {avg:.4f}s, Std = {std:.4f}s")

driver.close()

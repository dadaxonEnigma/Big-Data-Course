import pymongo
import json
import time
import statistics
from tabulate import tabulate
import os

client = pymongo.MongoClient("mongodb://localhost:27018/")
db = client["Ecommerce"]

campaigns_collection = db["campaigns"]
events_collection = db["events"]

QUERY_FILES = [
    "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/scripts/q1.js",  
    "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/scripts/q2.js"   
]

OUTPUT_DIR = "C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/output/"
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def create_text_index_for_events():
    try:
        events_collection.create_index([("category_code", "text")])
        print("Text index created for 'category_code' field in events collection")
    except Exception as e:
        print(f"Error when creating index in events: {e}")

create_text_index_for_events()

def execute_query_from_file(file_path, collection):
    with open(file_path, "r", encoding="utf-8") as file:
        query = json.load(file)
    start_time = time.time()
    result = list(collection.aggregate(query, allowDiskUse=True))
    end_time = time.time()
    exec_time = end_time - start_time
    return result, exec_time

all_execution_times = {script: [] for script in QUERY_FILES}
all_results = {script: [] for script in QUERY_FILES}  

for script in QUERY_FILES:
    if "q1" in script:
        coll = campaigns_collection
    elif "q2" in script:
        coll = events_collection
    else:
        coll = campaigns_collection  

    print(f"Running {script} 5 times...\n")
    for run in range(5):
        result, exec_time = execute_query_from_file(script, coll)
        all_execution_times[script].append(exec_time)
        if run == 0:
            all_results[script] = result
        print(f"Run {run+1}: Execution time: {exec_time:.4f} seconds")
        print("-" * 50)

for script, times in all_execution_times.items():
    avg_time = sum(times) / len(times)
    stdev_time = statistics.stdev(times) if len(times) > 1 else 0
    print(f"\nFor script {script}:")
    print(f"Average execution time: {avg_time:.4f} seconds")
    print(f"Standard deviation: {stdev_time:.4f} seconds")

    output_file = os.path.join(OUTPUT_DIR, f"Mongo_{os.path.basename(script).split('.')[0]}_result.txt")
    with open(output_file, "w", encoding="utf-8") as out_file:
        if all_results[script]:
            headers = all_results[script][0].keys()
            table = [list(doc.values()) for doc in all_results[script]]
            out_file.write(tabulate(table, headers=headers, tablefmt="grid"))
            out_file.write("\n\n")
        out_file.write(f"Average execution time: {avg_time:.4f} seconds\n")
        out_file.write(f"Standard deviation: {stdev_time:.4f} seconds\n")
    print(f"Results saved to {output_file}\n")

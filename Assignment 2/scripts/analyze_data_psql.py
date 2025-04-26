import psycopg2

def analyze_campaign_effectiveness():
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="ecommerce", 
        user="postgres", 
        password="root", 
        host="localhost", 
        port="5432"
    )
    
    cursor = conn.cursor()
    
    # Load the query from q1.sql
    with open('q1.sql', 'r') as file:
        query = file.read()
    
    cursor.execute(query)
    results = cursor.fetchall()
    
    # Print the results
    for row in results:
        print(f"Campaign {row[1]} ({row[2]} channel): {row[6]} clients reached, {row[7]} purchases made, {row[8]}% purchase rate")
    
    cursor.close()
    conn.close()

# Run the analysis
analyze_campaign_effectiveness()

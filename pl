import cx_Oracle

def fetch_data_from_oracle(main_job, dept_id):
    try:
        # Establish the database connection
        dsn_tns = cx_Oracle.makedsn('your_host', 'your_port', service_name='your_service_name')
        connection = cx_Oracle.connect(user='your_username', password='your_password', dsn=dsn_tns)
        
        # Create a cursor object
        cursor = connection.cursor()
        
        # Define the query with parameters
        query = """
        SELECT *
        FROM your_table_name
        WHERE main_job = :main_job AND dept_id = :dept_id
        """
        
        # Execute the query with the provided parameters
        cursor.execute(query, main_job=main_job, dept_id=dept_id)
        
        # Fetch all the results
        results = cursor.fetchall()
        
        # Print the column names
        columns = [col[0] for col in cursor.description]
        print(columns)
        
        # Print the results
        for row in results:
            print(row)
        
    except cx_Oracle.DatabaseError as e:
        print(f"Database error occurred: {e}")
    
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if connection:
            connection.close()

if __name__ == "__main__":
    main_job = input("Enter the main_job: ")
    dept_id = input("Enter the dept_id: ")
    fetch_data_from_oracle(main_job, dept_id)

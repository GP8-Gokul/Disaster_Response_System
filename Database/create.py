import sqlite3

db="disaster.db"
<<<<<<< HEAD

create_table_sql = '''
    CREATE TABLE aid_distribution (
    distribution_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    resource_id INTEGER,
    volunteer_id INTEGER,
    quantity_distributed INTEGER NOT NULL,
    distribution_date DATE NOT NULL,
    location VARCHAR NOT NULL,
    FOREIGN KEY (event_id) REFERENCES disaster_events (event_id),
    FOREIGN KEY (resource_id) REFERENCES resources (resource_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteers (volunteer_id)
);

'''
#connect sqlite  database
conn = sqlite3.connect(db)

# Create a cursor
cur = conn.cursor()

try:
    cur.execute(create_table_sql)
    conn.commit()
    print("Table created successfully.")
except sqlite3.Error as e:
    print(f"An error occurred: {e}")

# Close connection
conn.close()
=======

create_table_sql = '''
    CREATE TABLE aid_distribution (
    distribution_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    resource_id INTEGER,
    volunteer_id INTEGER,
    quantity_distributed INTEGER NOT NULL,
    distribution_date DATE NOT NULL,
    location VARCHAR NOT NULL,
    FOREIGN KEY (event_id) REFERENCES disaster_events (event_id),
    FOREIGN KEY (resource_id) REFERENCES resources (resource_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteers (volunteer_id)
);

'''
#connect sqlite  database
conn = sqlite3.connect(db)

# Create a cursor
cur = conn.cursor()

try:
    cur.execute(create_table_sql)
    conn.commit()
    print("Table created successfully.")
except sqlite3.Error as e:
    print(f"An error occurred: {e}")

# Close connection
conn.close()

>>>>>>> 1131abcb546dfca46bea7c8247d32666d98305fb
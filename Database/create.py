import sqlite3

db="disaster.db"

create_aid_distribution_sql = '''
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

create_disaster_events ='''
    CREATE TABLE disaster_events(
        event _ id INTEGER PRIMARY KEY AUTOINCREMENT, 
        event_name VARCHAR NOT NULL,
        event_type VARCHAR NOT NULL,
        location VARCHAR NOT NULL, 
        start date DATE NOT NULL,
        end date DATE,
        description TEXT
    )
'''


#connect sqlite  database
conn = sqlite3.connect(db)

# Create a cursor
cur = conn.cursor()
cur.execute(create_aid_distribution_sql)
cur.execute(create_disaster_events)
conn.commit()
print("Table created successfully.")


# Close connection
conn.close()


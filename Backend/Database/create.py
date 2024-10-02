import sqlite3

db = "Backend/Database/disaster.db"

create_aid_distribution_sql = '''
    CREATE TABLE aid_distribution (
    distribution_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    resource_id INTEGER,
    volunteer_id INTEGER,
    quantity_distributed INTEGER NOT NULL,
    distribution_date DATE NOT NULL,
    location VARCHAR NOT NULL,
    FOREIGN KEY (event_id) REFERENCES disaster_events (event_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources (resource_id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES volunteers (volunteer_id) ON DELETE CASCADE
);
'''

create_disaster_events = '''
    CREATE TABLE disaster_events(
        event_id INTEGER PRIMARY KEY AUTOINCREMENT, 
        event_name VARCHAR NOT NULL,
        event_type VARCHAR NOT NULL,
        location VARCHAR NOT NULL, 
        start_date DATE NOT NULL,
        end_date DATE,
        description TEXT
    );
'''

create_incident_report = '''
    CREATE TABLE incident_reports(
    report_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    report_date DATE NOT NULL,
    description TEXT,
    reported_by VARCHAR,
    report_name TEXT,
    FOREIGN KEY(event_id) REFERENCES disaster_events(event_id) ON DELETE CASCADE
 );
'''

create_resource = '''
    CREATE TABLE resources(
    resource_id INTEGER PRIMARY KEY AUTOINCREMENT,
    resource_name VARCHAR NOT NULL,
    resource_type VARCHAR NOT NULL, 
    quantity INTEGER, 
    availability_status VARCHAR NOT NULL,
    event_id INTEGER,
    FOREIGN KEY (event_id) REFERENCES disaster_events(event_id) ON DELETE CASCADE
    );
'''

create_users = '''
    CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR NOT NULL,
    password_hash VARCHAR NOT NULL, 
    role VARCHAR NOT NULL,
    email VARCHAR NOT NULL 
    );
'''

create_volunteers = '''
    CREATE TABLE volunteers( 
    volunteer_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name VARCHAR NOT NULL, 
    contact_info VARCHAR NOT NULL,
    skills VARCHAR, 
    availability_status VARCHAR NOT NULL, 
    event_id INTEGER,
    FOREIGN KEY (event_id) REFERENCES disaster_events(event_id) on DELETE CASCADE
    );
'''

# Connect to SQLite database
conn = sqlite3.connect(db)

# Create a cursor
cur = conn.cursor()
cur.execute(create_aid_distribution_sql)
cur.execute(create_disaster_events)
cur.execute(create_incident_report)
cur.execute(create_resource)
cur.execute(create_users)
cur.execute(create_volunteers)
conn.commit()
print("Tables created successfully.")

# Close connection
conn.close()

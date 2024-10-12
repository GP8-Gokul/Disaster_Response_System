# get_disaster_events()
# get_resources()
# get_volunteers()
# get_aid_distribution()
# get_incident_reports()
# get_record_by_id(table, record_id)

from .connect import get_cursor, commit;

def get_disaster_events():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM disaster_events")
        rows = cursor.fetchall()

        column_names = ['event_id', 'event_name', 'event_type', 'location', 'start_date', 'end_date', 'description']

        disaster_events = [dict(zip(column_names, row)) for row in rows]

    except:
        return None

    return (disaster_events)

def get_resources():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM resources")
        rows = cursor.fetchall()

        column_names = ['resource_id', 'resource_name', 'resource_type', 'quantity', 'availability_status', 'event_id']

        resources = [dict(zip(column_names, row)) for row in rows]

    except:
        return None

    return (resources)

def get_volunteers():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM volunteers")
        rows = cursor.fetchall()

        column_names = ['volunteer_id', 'volunteer_name', 'volunteer_contact_info', 'volunteer_skills', 'volunteer_availability_status', 'event_id']
    
        volunteers = [dict(zip(column_names, row)) for row in rows]

    except:
        return None

    return (volunteers)

def get_aid_distribution():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM aid_distribution")
        rows = cursor.fetchall()

        column_names = ['distribution_id','event_id', 'resource_id', 'volunteer_id', 'quantity_distributed', 'distribution_date', 'location']

        aid_distribution = [dict(zip(column_names, row)) for row in rows]

    except:
        return None

    return (aid_distribution)

def get_incident_reports():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM incident_reports")
        rows = cursor.fetchall()

        column_names = ['report_id', 'event_id', 'report_date', 'report_description', 'reported_by', 'report_name']

        incident_reports = [dict(zip(column_names, row)) for row in rows]


    except:
        return None

    return (incident_reports)

def get_messages():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM messages")
        rows = cursor.fetchall()

        column_names = ['id', 'sender', 'text', 'event_id']

        messages = [dict(zip(column_names, row)) for row in rows]

    except:
        return None

    return (messages)

def get_record_by_id(table, record_id):
    cursor = get_cursor()
    
    try: 
        if(table == 'disaster_events'):
            cursor.execute(f"SELECT * FROM {table} WHERE event_id = ?",(record_id,))
            row = cursor.fetchone()
            column_names = ['event_id', 'event_name', 'event_type', 'location', 'start_date', 'end_date', 'description']
        elif(table == 'resources'):
            cursor.execute(f"SELECT * FROM {table} WHERE resource_id = ?",(record_id,))
            row = cursor.fetchone()
            column_names = ['resource_id', 'resource_name', 'resource_type', 'quantity', 'availability_status', 'event_id']
        elif(table == 'volunteers'):
            cursor.execute(f"SELECT * FROM {table} WHERE volunteer_id = ?",(record_id,))
            row = cursor.fetchone()
            column_names = ['volunteer_id', 'volunteer_name', 'volunteer_contact_info', 'volunteer_skills', 'volunteer_availability_status', 'event_id']
        elif(table == 'aid_distribution'):
            cursor.execute(f"SELECT * FROM {table} WHERE distribution_id = ?",(record_id,))
            row = cursor.fetchone()
            column_names = ['distribution_id','event_id', 'resource_id', 'volunteer_id', 'quantity_distributed', 'distribution_date', 'location']
        elif(table == 'incident_reports'):
            cursor.execute(f"SELECT * FROM {table} WHERE report_id = ?",(record_id,))
            row = cursor.fetchone()
            column_names = ['report_id', 'event_id', 'report_date', 'report_description', 'reported_by', 'report_name']
        
        row = dict(zip(column_names, row))

    except:
        return None

    return row
















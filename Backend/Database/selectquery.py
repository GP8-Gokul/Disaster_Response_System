# get_disaster_events()
# get_resources()
# get_volunteers()
# get_aid_distribution()
# get_incident_reports()
# get_record_by_id(table, record_id)

from .connect import get_cursor, commit;
from flask import jsonify;

def get_disaster_events():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM disaster_events")
        rows = cursor.fetchall()

        column_names = ['event_id', 'event_name', 'event_type', 'location', 'start_date', 'end_date', 'description']

        disaster_events = [dict(zip(column_names, row)) for row in rows]

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(disaster_events)

def get_resources():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM resources")
        rows = cursor.fetchall()

        column_names = ['resource_id', 'resource_name', 'resource_type', 'quantity', 'availability_status', 'event_id']

        resources = [dict(zip(column_names, row)) for row in rows]

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(resources)

def get_volunteers():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM volunteers")
        rows = cursor.fetchall()

        column_names = ['volunteer_id', 'volunteer_name', 'volunteer_contact_info', 'volunteer_skills', 'volunteer_availability_status', 'event_id']
    
        volunteers = [dict(zip(column_names, row)) for row in rows]

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(volunteers)

def get_aid_distribution():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM aid_distribution")
        rows = cursor.fetchall()

        column_names = ['distribution_id','event_id', 'resource_id', 'volunteer_id', 'quantity_distributed', 'distribution_date', 'location']

        aid_distribution = [dict(zip(column_names, row)) for row in rows]

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(aid_distribution)

def get_incident_reports():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM incident_reports")
        rows = cursor.fetchall()

        column_names = ['report_id', 'event_id', 'report_date', 'report_description', 'reported_by']

        incident_reports = [dict(zip(column_names, row)) for row in rows]

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(incident_reports)

def get_record_by_id(table, record_id):
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM ? WHERE id = ?",(table,record_id))
        row = cursor.fetchone()

        if(table == 'disaster_events'):
            column_names = ['event_id', 'event_name', 'event_type', 'location', 'start_date', 'end_date', 'description']
        elif(table == 'resources'):
            column_names = ['resource_id', 'resource_name', 'resource_type', 'quantity', 'availability_status', 'event_id']
        elif(table == 'volunteers'):
            column_names = ['volunteer_id', 'volunteer_name', 'volunteer_contact_info', 'volunteer_skills', 'volunteer_availability_status', 'event_id']
        elif(table == 'aid_distribution'):
            column_names = ['distribution_id','event_id', 'resource_id', 'volunteer_id', 'quantity_distributed', 'distribution_date', 'location']
        elif(table == 'incident_reports'):
            column_names = ['report_id', 'event_id', 'report_date', 'report_description', 'reported_by']
        
        row = dict(zip(column_names, row))

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(row)















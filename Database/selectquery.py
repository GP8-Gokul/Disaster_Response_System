# get_disaster_events()
# get_resources()
# get_volunteers()
# get_aid_distribution()
# get_incident_reports()
# get_record_by_id(table, record_id)

from connect import get_cursor, commit;
from flask import jsonify;

def get_disaster_events():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM disaster_events")
        rows = cursor.fetchall()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(rows)

def get_resources():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM resources")
        rows = cursor.fetchall()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(rows)

def get_volunteers():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM volunteers")
        rows = cursor.fetchall()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(rows)

def get_aid_distribution():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM aid_distribution")
        rows = cursor.fetchall()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(rows)

def get_incident_reports():
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM incident_reports")
        rows = cursor.fetchall()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(rows)

def get_record_by_id(table, record_id):
    cursor = get_cursor()
    
    try:
        cursor.execute("SELECT * FROM {} WHERE id = {}".format(table, record_id))
        row = cursor.fetchone()

        commit()

    except:
        return None

    finally:
        cursor.close()

    return jsonify(row)















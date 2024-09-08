# get_disaster_events()
# get_resources()
# get_volunteers()
# get_aid_distribution()
# get_incident_reports()
# get_record_by_id(table, record_id)


from connect import get_cursor, commit;

def get_disaster_events():
    cursor = get_cursor()
    
    try:
        disaster_events_dict = {}

        cursor.execute("SELECT * FROM disaster_events")
        rows = cursor.fetchall()

        for row in rows:
            event_id = row[0]
            event_info = list(row[1:])
            disaster_events_dict[event_id] = event_info

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return disaster_events_dict

def get_resources():
    cursor = get_cursor()
    
    try:
        resources_dict = {}

        cursor.execute("SELECT * FROM resources")
        rows = cursor.fetchall()

        for row in rows:
            resource_id = row[0]
            resource_info = list(row[1:])
            resources_dict[resource_id] = resource_info

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return resources_dict

def get_volunteers():
    cursor = get_cursor()
    
    try:
        volunteers_dict = {}

        cursor.execute("SELECT * FROM volunteers")
        rows = cursor.fetchall()

        for row in rows:
            volunteer_id = row[0]
            volunteer_info = list(row[1:])
            volunteers_dict[volunteer_id] = volunteer_info

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return volunteers_dict

def get_aid_distribution():
    cursor = get_cursor()
    
    try:
        aid_distribution_dict = {}

        cursor.execute("SELECT * FROM aid_distribution")
        rows = cursor.fetchall()

        for row in rows:
            aid_id = row[0]
            aid_info = list(row[1:])
            aid_distribution_dict[aid_id] = aid_info

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return aid_distribution_dict

def get_incident_reports():
    cursor = get_cursor()
    
    try:
        incident_reports_dict = {}

        cursor.execute("SELECT * FROM incident_reports")
        rows = cursor.fetchall()

        for row in rows:
            report_id = row[0]
            report_info = list(row[1:])
            incident_reports_dict[report_id] = report_info

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return incident_reports_dict

def get_record_by_id(table, record_id):
    cursor = get_cursor()
    
    try:
        record_dict = {}

        cursor.execute("SELECT * FROM {} WHERE id = {}".format(table, record_id))
        row = cursor.fetchone()

        if row is not None:
            record_info = list(row[1:])
            record_dict[record_id] = record_info
        else:
            return None

        commit()
    except Exception as e:
        print(e)
        return None

    finally:
        cursor.close()

    return record_dict















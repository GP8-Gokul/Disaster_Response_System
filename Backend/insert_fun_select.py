from Database.insert import *

def insert_interface(data):
    pass
    try:
        jdata = json.loads(data) if isinstance(data, str) else data


        table = jdata.pop('table',None)
        if not table:
            return {"status": "error", "message": "Invalid table."}

       
        if table == 'users':
            return insert_users(jdata)
        elif table == 'disaster_events':
            return insert_disaster_events(jdata)
        elif table == 'resources':
            return insert_resources(jdata)
        elif table == 'volunteers':
            return insert_volunteers(jdata)
        elif table == 'incident_reports':
            return insert_incident_reports(jdata)
        elif table == 'aid_distribution':
            return insert_aid_distribution(jdata)
        else:
            return {"status": "error", "message": f"Unknown table: {table}"}


    except Exception as e:
        return {"status": "error", "message": str(e)}

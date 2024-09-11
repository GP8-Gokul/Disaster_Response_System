from Database.insert import *

def insert_interface(data):
  
    try:
        jdata = json.loads(data) if isinstance(data, str) else data


        table = jdata.pop('table',None)
        if not table:
            return {"status": "error", "message": "Invalid table."}

       
        if table == 'users':
            return insert_users(jdata[username], jdata[password_hash],jdata[role])
        elif table == 'disaster_events':
            return insert_disaster_events(jdata[event_name], jdata[event_type],jdata[location],jdata[start_date],jdata[end_date],jdata[description])
        elif table == 'resources':
            return insert_resources(jdata[resource_name],jdata[resource_type],jdata[quantity],jdata[availability_status],jdata[event_id])
        elif table == 'volunteers':
            return insert_volunteers(jdata[name],jdata[contact_info],jdata[skills],jdata[availability_status],jdata[event_id])
        elif table == 'incident_reports':
            return insert_incident_reports(jdata[event_id],jdata[report_date],jdata[description],jdata[reported_by])
        elif table == 'aid_distribution':
            return insert_aid_distribution(jdata[event_id],jdata[resource_id],jdata[volunteer_id],jdata[quanity_distributed],jdata[distribution_date],jdata[location])
        else:
            return {"status": "error", "message": f"Unknown table: {table}"}


    except Exception as e:
        return {"status": "error", "message": str(e)}
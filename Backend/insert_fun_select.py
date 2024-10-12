from Database.insert import *

def insert_interface(data):
  
    try:

        table = data.pop('table',None)

       
        if table == 'users':
            # insert_user(data['username'], data['password_hash'],data['role'])
            pass


        elif table == 'disaster_events':
            insert_disaster_event(data['event_name'], data['event_type'],data['location'],data['start_date'],data['end_date'],data['description'])


        elif table == 'resources':
            insert_resource(data['resource_name'],data['resource_type'],data['quantity'],data['availability_status'],data['event_id'])


        elif table == 'volunteers':
             insert_volunteer(data['name'],data['contact_info'],data['skills'],data['availability_status'],data['event_id'])


        elif table == 'incident_reports':
             insert_incident_report(data['event_id'],data['report_date'],data['description'],data['reported_by'],data['report_name'])


        elif table == 'aid_distribution':
             insert_aid_distribution(data['event_id'],data['resource_id'],data['volunteer_id'],data['quantity_distributed'],data['distribution_date'],data['location'])

        elif table == 'messages':
            insert_message(data['sender'],data['text'],data['event_id'])

        else:
            return {"status": "error", "message": f"Unknown table: {table}"}


        return {"status": "success", "message": f"Inserted data into table: {table}"}



    except Exception as e:
        return {"status": "error", "message": str(e)}
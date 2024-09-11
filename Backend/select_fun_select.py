from Database.select import *
import json

def select_interface(data):

    try:
        table = data.pop('table', None)

        if table == 'users':
           
            return select_user(data['username'])

        elif table == 'disaster_events':
            
            return select_disaster_event(data['event_name'], data.get('event_type'), data.get('location'),data.get('start_date'),data.get('end_date'))

        elif table == 'resources':
            
            return select_resource(data['resource_name'], data.get('resource_type'),data.get('quantity'),data.get('availability_status'),)

        elif table == 'volunteers':
            
            return select_volunteer(data['name'], data.get('skills'), data.get('availability_status'),data.get('contact_info'))

        elif table == 'incident_reports':
            
            return select_incident_report(data['event_id'], data.get('report_date'),data.get('description'))

        elif table == 'aid_distribution':
            
            return select_aid_distribution(data['event_id'], data.get('quantity_distributed'), data.get('distribution_date'),data.get('location'))

        else:
            return {"status": "error", "message": f"Unknown table: {table}"}

    except Exception as e:
        return {"status": "error", "message": str(e)}

#insert_disaster_event(event_name, event_type, location, start_date, end_date=None, description=None)
#insert_resource(resource_name, resource_type, quantity, availability_status, event_id=None)
#insert_volunteer(name, contact_info, skills, availability_status, event_id=None)
#insert_aid_distribution(event_id, resource_id, volunteer_id, quantity_distributed, distribution_date, location)
#insert_user(username, password_hash, role)
#insert_incident_report(event_id, report_date, description, reported_by)



from connect import get_cursor, commit;




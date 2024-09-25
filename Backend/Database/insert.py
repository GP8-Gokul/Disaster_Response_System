#insert_disaster_event(event_name, event_type, location, start_date, end_date=None, description=None)
#insert_resource(resource_name, resource_type, quantity, availability_status, event_id=None)
#insert_volunteer(name, contact_info, skills, availability_status, event_id=None)
#insert_aid_distribution(event_id, resource_id, volunteer_id, quantity_distributed, distribution_date, location)
#insert_user(username, password_hash, role)
#insert_incident_report(event_id, report_date, description, reported_by)



from .connect import get_cursor, commit;

def insert_disaster_event(event_name, event_type, location, start_date, end_date=None, description=None):
 cursor=get_cursor()
 cursor.execute("insert into disaster_events(event_name,event_type, location,start_date,end_date,description) values(?,?,?,?,?,?);",(event_name,event_type, location,start_date,end_date,description))
 commit()


def insert_resource(resource_name, resource_type, quantity, availability_status, event_id=None):
 cursor=get_cursor()
 cursor.execute("insert into resources(resource_name,resource_type,quantity,availability_status,event_id) values(?,?,?,?,?);",(resource_name,resource_type,quantity,availability_status,event_id))
 commit()


def insert_volunteer(name, contact_info, skills, availability_status, event_id=None):
 cursor=get_cursor()
 cursor.execute("insert into volunteers(name,contact_info,skills,availability_status,event_id) values(?,?,?,?,?);",(name,contact_info,skills,availability_status,event_id))
 commit()


def insert_aid_distribution(event_id, resource_id, volunteer_id, quantity_distributed, distribution_date, location):
 cursor=get_cursor()
 cursor.execute("insert into aid_distribution(event_id,resource_id,volunteer_id,quantity_distributed, distribution_date,location) values(?,?,?,?,?,?);",(event_id,resource_id,volunteer_id,quantity_distributed, distribution_date,location))
 commit()


# def insert_user(username, password_hash, role):
#  cursor=get_cursor()
#  cursor.execute("insert into users(username,password_hash,role) values(?,?,?);",(username,password_hash,role))
#  commit()


def insert_incident_report(event_id, report_date, description, reported_by):
 cursor=get_cursor()
 cursor.execute("insert into incident_reports(event_id,report_date,description,reported_by) values(?,?,?,?);",(event_id,report_date,description,reported_by))
 commit()


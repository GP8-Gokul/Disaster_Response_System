from Database.update import *
def update_interface(data):
    try:
    
        if "table" not in data:
            return {"status": "error", "message": "'table' key is missing in the request data"}, 400

        table = data["table"]

        if "record_id" in data and data["record_id"]:
            record_id = data["record_id"]
            return update_record(table,data.get("column"),data.get("value"),record_id,data.get("condition_column"))


        if table == "disaster_events":
            return update_disaster_event(data.get("event_id"), data.get("event_name"), data.get("event_type"), data.get("location"), data.get("start_date"), data.get("end_date"), data.get("description"))
        
        elif table == "resources":
            return update_resource(data.get("resource_id"), data.get("resource_name"), data.get("resource_type"), data.get("quantity"), data.get("availability_status"), data.get("event_id"))

        elif table == "volunteers":
            return update_volunteer(data.get("volunteer_id"), data.get("name"), data.get("contact_info"), data.get("skills"), data.get("availability_status"), data.get("event_id"))
            
        elif table == "incident_reports":
            return update_incident_report(data.get("report_id"), data.get("event_id"), data.get("report_date"), data.get("description"), data.get("reported_by"))
            
        elif table == "aid_distribution":
            return update_aid_distribution(data.get("distribution_id"), data.get("event_id"),data.get("resource_id"),data.get("volunteer_id"),data.get("quantity_distributed"),data.get("distribution_date"),data.get("location"))
        
        else:
            return {"status": "error", "message": "Invalid table name"}, 400

    except Exception as e:
        return {"status": "error", "message": f"An error occurred: {str(e)}"}, 500

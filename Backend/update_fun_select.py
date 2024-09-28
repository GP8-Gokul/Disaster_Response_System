from Database.update import *

def update_interface(data):
    try:
        if "table" not in data:
            return {"status": "error", "message": "'table' key is missing in the request data"}, 400

        table = data["table"]

        # if data["condition_value"]:
        #     result = update_record(table, data.get("column"), data.get("value"), data.get("condition_column"),data.get("condition_value"))
        #     return result if result else {"status": "success", "message": "Record updated successfully"}, 200

        if table == "disaster_events":
            result = update_disaster_event(table, data.get("event_id"), data.get("event_name"), data.get("event_type"), data.get("location"), data.get("start_date"), data.get("end_date"), data.get("description"))
        
        elif table == "resources":
            result = update_resource(table, data.get("resource_id"), data.get("resource_name"), data.get("resource_type"), data.get("quantity"), data.get("availability_status"), data.get("event_id"))

        elif table == "volunteers":
            result = update_volunteer(table, data.get("volunteer_id"), data.get("volunteer_name"), data.get("volunteer_contact_info"), data.get("volunteer_skills"), data.get("volunteer_availability_status"), data.get("event_id"))
            
        elif table == "incident_reports":
            result = update_incident_report(table, data.get("report_id"), data.get("event_id"), data.get("report_date"), data.get("description"), data.get("reported_by"))
            
        elif table == "aid_distribution":
            result = update_aid_distribution(table, data.get("distribution_id"), data.get("event_id"), data.get("resource_id"), data.get("volunteer_id"), data.get("quantity_distributed"), data.get("distribution_date"), data.get("location"))
        
        else:
            return {"status": "error", "message": "Invalid table name"}, 400

        return result if result else {"status": "success", "message": f"{table} updated successfully"}, 200

    except Exception as e:
        return {"status": "error", "message": f"An error occurred: {str(e)}"}, 500

from Database.selectquery import *


def select_interface(data):
    try:
        if "table" not in data:
            return {"status": "error", "message": "'table' key is missing in the request data"}, 400

        table = data["table"]

        if "record_id" in data and data["record_id"]:
            record_id = data["record_id"]
            return get_record_by_id(table, record_id)
        
        if table == "disaster_events":
            return get_disaster_events()
        elif table == "resources":
            return get_resources()
        elif table == "volunteers":
            return get_volunteers()
        elif table == "aid_distribution":
            return get_aid_distribution()
        elif table == "incident_reports":
            return get_incident_reports()
        else:
            return {"status": "error", "message": "Invalid table name"}, 400

    except Exception as e:
        return {"status": "error", "message": f"An error occurred: {str(e)}"}, 500

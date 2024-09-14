from Database.selectquery import *
import json

def select_interface(data):

    try:
        if data["record_id"]:
            return get_record_by_id(data["table"], data["record_id"])
        if data["table"] == "disaster_events":
            return get_disaster_events()
        elif data["table"] == "resources":
            return get_resources()
        elif data["table"] == "volunteers":
            return get_volunteers()
        elif data["table"] == "aid_distribution":
            return get_aid_distribution()
        elif data["table"] == "incident_reports":
            return get_incident_reports()
        else:
            return {"status": "error", "message": "Invalid table name"}
        

    except Exception as e:
        return {"status": "error", "message": str(e)}

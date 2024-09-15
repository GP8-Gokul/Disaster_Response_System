from Database.update import *

def update_interface(data):
    
    try:
        update_record(data["table"], data["column"], data["value"], data["condition_column"], data["condition_value"])

    except Exception as e:
        return {"status": "error", "message": str(e)}
    
    return {"status": "success", "message": "Record updated successfully."}
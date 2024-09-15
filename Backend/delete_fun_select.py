from Database.delete import *

def delete_interface(data):

    try:
        delete_record(data["table"], data["column"], data["value"])

    except Exception as e:
        return {"status": "error", "message": str(e)}
    
    return {"status": "success", "message": "Record deleted successfully."}

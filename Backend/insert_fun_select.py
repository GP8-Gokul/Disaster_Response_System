from Database.insert import *

def insert_interface(data):
    pass
    try:
        jdata = json.loads(data) if isinstance(data, str) else data


        table = jdata.get('table')
        if not table:
            return {"status": "error", "message": "Invalid table."}

        # Call the appropriate function based on the table name
        if table == 'users':
            return insert_into_users(jdata)
        elif table == 'orders':
            return insert_into_orders(jdata)
        else:
            return {"status": "error", "message": f"Unknown table: {table}"}


    except Exception as e:
        return {"status": "error", "message": str(e)}

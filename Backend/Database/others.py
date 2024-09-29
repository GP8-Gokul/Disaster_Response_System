from .connect import get_cursor

def disaster_name_id_select():
    cursor = get_cursor()
    cursor.execute("SELECT event_id, event_name FROM disaster_events")
    rows = cursor.fetchall()
    response = {row[0]: row[1] for row in rows}
    return response

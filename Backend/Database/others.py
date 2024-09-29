from .connect import get_cursor

def disaster_name_id_select():
    cursor = get_cursor()
    cursor.execute("SELECT event_id,event_name FROM disaster_events")
    rows = cursor.fetchall()
    column_names = ['event_id', 'event_name']
    response = [dict(zip(column_names, row)) for row in rows]
    return response
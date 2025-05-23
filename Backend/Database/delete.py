# delete_record(table, column, value)

from .connect import get_cursor, commit;

def delete_record(table, column, value):
    cursor = get_cursor()
    cursor.execute(f"DELETE FROM {table} WHERE {column} = ?",(value,))
    commit()
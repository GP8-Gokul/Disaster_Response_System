# update_record(table, column, value, condition_column, condition_value)

from .connect import get_cursor, commit;

def update_record(table, column, value, condition_column, condition_value):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET {column} = ? WHERE {condition_column} = ?", (value, condition_value))
    except Exception as e:
        print(f"An error occurred: {e}")
    else:
        print("Record updated successfully")
    commit()
# update_record(table, column, value, condition_column, condition_value)

from .connect import get_cursor, commit;

def update_record(table, column, value, condition_column, condition_value):
    cursor = get_cursor()
    cursor.execute(f"UPDATE ? SET ? = ? WHERE ? = ?",(table,column,value,condition_column,condition_value))
    commit()
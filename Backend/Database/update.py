from .connect import get_cursor, commit


def update_record(table, column, value, condition_column, condition_value):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET {column} = ? WHERE {condition_column} = ?", (value, condition_value))
        commit()
        return {"status": "success", "message": f"Record in {table} updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating {table}: {e}"}


def update_volunteer(table, volunteer_id, name, contact_info, skills, availability_status, event_id):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET name = ?, contact_info = ?, skills = ?, availability_status = ?, event_id = ? WHERE volunteer_id = ?", (name, contact_info, skills, availability_status, event_id, volunteer_id))
        commit()
        return {"status": "success", "message": "Volunteer updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating volunteer: {e}"}


def update_disaster_event(table, event_id, event_name, event_type, location, start_date, end_date, description):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET event_name = ?, event_type = ?, location = ?, start_date = ?, end_date = ?, description = ? WHERE event_id = ?", (event_name, event_type, location, start_date, end_date, description, event_id))
        commit()
        return {"status": "success", "message": "Disaster event updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating disaster event: {e}"}


def update_resource(table, resource_id, resource_name, resource_type, quantity, availability_status, event_id):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET resource_name = ?, resource_type = ?, quantity = ?, availability_status = ?, event_id = ? WHERE resource_id = ?", (resource_name, resource_type, quantity, availability_status, event_id, resource_id))
        commit()
        return {"status": "success", "message": "Resource updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating resource: {e}"}


def update_incident_report(table, report_id, event_id, report_date, description, reported_by):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET event_id = ?, report_date = ?, description = ?, reported_by = ? WHERE report_id = ?", (event_id, report_date, description, reported_by, report_id))
        commit()
        return {"status": "success", "message": "Incident report updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating incident report: {e}"}


def update_aid_distribution(table, distribution_id, event_id, resource_id, volunteer_id, quantity_distributed, distribution_date, location):
    cursor = get_cursor()
    try:
        cursor.execute(f"UPDATE {table} SET event_id = ?, resource_id = ?, volunteer_id = ?, quantity_distributed = ?, distribution_date = ?, location = ? WHERE distribution_id = ?", (event_id, resource_id, volunteer_id, quantity_distributed, distribution_date, location, distribution_id))
        commit()
        return {"status": "success", "message": "Aid distribution updated successfully"}
    except Exception as e:
        return {"status": "error", "message": f"An error occurred while updating aid distribution: {e}"}

        




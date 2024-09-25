from .connect import get_cursor,commit

def signup_interface(data):

    try:
        username = data['username']
        password = data['password']
        role = data['role']
        email = data['email']
        cursor = get_cursor()
        cursor.execute("select count(*) from users where username = ?", (data['username'],))
        result=cursor.fetchone()
        if result[0]>0:
            return "User already exists"
        else:
            cursor.execute("insert into users(username,password_hash,role,email) values(?,?,?,?)", (username, password, role,email))
            commit()
            return "User created successfully"
    except Exception as e:
        print(f"An error occurred: {e}")
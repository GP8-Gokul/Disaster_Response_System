from .connect import get_cursor

def login_interface(data):
    username=data['username']
    password=data['password']
    cursor=get_cursor()
    cursor.execute(f"select * from users where username=? and password_hash=?",(username,password))
    result=cursor.fetchall()
    if len(result)==0:
        return False
    else:
        return True
from Database.signup import signup_interface
from Database.login import login_interface

from delete_fun_select import delete_interface
from insert_fun_select import insert_interface
from select_fun_select import select_interface
from update_fun_select import update_interface

from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager, jwt_required, create_access_token

app = Flask(__name__)
CORS(app)

app.config['JWT_SECRET_KEY'] = 'jaggajasoos'
jwt = JWTManager(app)


@app.route('/', methods=['GET'])
@jwt_required()
def home():
    return jsonify(message="Hello, World!")

@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    result=signup_interface(data)
    return jsonify(result)


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if(login_interface(data)):
        token = create_access_token(identity=data['username'])
    else:
        token = "Invalid"
    return jsonify(token)

@app.route('/insert', methods=['POST'])
@jwt_required()
def insert():
    data = request.get_json()
    return jsonify(insert_interface(data))

@app.route('/delete', methods=['POST'])
@jwt_required()
def delete():
    data = request.get_json()
    return jsonify(delete_interface(data))

@app.route('/update', methods=['POST'])
@jwt_required()
def update():
    data = request.get_json()
    return jsonify(update_interface(data))

@app.route('/select', methods=['POST'])
def select():
    data = request.get_json()
    return jsonify(select_interface(data))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)





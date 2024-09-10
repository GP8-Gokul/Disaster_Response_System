from delete_fun_select import delete_interface
from insert_fun_select import insert_interface
from select_fun_select import select_interface
from update_fun_select import update_interface

from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/', methods=['GET'])
def home():
    return "Hello, World!"

@app.route('/insert', methods=['POST'])
def insert():
    data = request.get_json()
    return jsonify(insert_interface(data))

@app.route('/delete', methods=['POST'])
def delete():
    data = request.get_json()
    return jsonify(delete_interface(data))

@app.route('/update', methods=['POST'])
def update():
    data = request.get_json()
    return jsonify(update_interface(data))

@app.route('/select', methods=['POST'])
def select():
    data = request.get_json()
    return jsonify(select_interface(data))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)





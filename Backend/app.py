from insert import *
from delete import *
from update import *
from selectquery import *

from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/', methods=['POST'])
def home():
    return "Welcome to the backend"



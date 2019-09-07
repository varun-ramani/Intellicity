from app import app
from flask import request
import json
from auth import authenticate_user, register_user

@app.route("/", methods=['GET'])
def index():
    return "App started successfully"

@app.route("/api/login", methods=['POST'])
def login():
    data = json.loads(request.data)
    authentication = authenticate_user(data['email'], data['password'])
    if authentication == None:
        return json.dumps({"status": "error"})
    else:
        return json.dumps({"status": "success", "authtoken": authentication})

@app.route("/api/register", methods=['POST'])
def register():
    data = json.loads(request.data)
    authentication = register_user(data['email'], data['password'])
    if authentication == None:
        return json.dumps({"status": "error"})
    else:
        return json.dumps({"status": "success", "authtoken": authentication})
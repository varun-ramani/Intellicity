from app import app
from flask import request
import json
from auth import authenticate_user, register_user, decode_jwt
from database import add, retrieve, get_image

CONV = .01447178

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


@app.route("/api/retrieve", methods=['POST'])
def getreports():
    data = json.loads(request.data)

    if data.get('longitude') == None or data.gets('latitude') == None:
        success = False
    else:
        longitude = float(data.get('longitude'))
        latitiude = float(data.get('latitude'))
        lower_lat = latitiude - (2.5*CONV)
        upper_lat = latitiude + (2.5*CONV)
        lower_long = longitude - (2.5*CONV)
        upper_long = longitude + (2.5*CONV)
        success = True

    if success == False:
        return json.dumps({"status": "error"})
    else:
        return retrieve(upper_lat, lower_lat, upper_long, lower_long)

@app.route("/api/retrieveimg", methods=['POST'])
def getimg():
    try:
        data = json.loads(request.data)
        print(data.get('id'))
        if data.get('id') == None:
            success = False
        else:
            success = True

        if success == False:
            return json.dumps({"status": "error"})
        else:
            return get_image(data.get('id'))
    except:
        return json.dumps({"status": "error"})


@app.route("/api/add", methods=['POST'])
def addreport():
    print(request.data)
    try:
        data = json.loads(request.data)
        data = {
            'email': decode_jwt(data.get('authtoken'))['email'],
            'longitude': float(data.get('longitude')),
            'latitude': float(data.get('latitude')),
            'image': data.get('image'),
            'description': data.get('description'),
            'tags': data.get('tags')
        }
        if data['longitude'] == None or data['latitude'] ==  None or data['email'] == None:
            success = False
        else:
            report_id = add(data)
            if report_id != None:
                success = True
            else:
                success = False
        if success == False:
            return json.dumps({"status": "error"})
        else:
            return json.dumps({"status": "success"})
    except:
        return json.dumps({"status": "error"})

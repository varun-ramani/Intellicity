from flask import Flask
from flask_cors import CORS
import socketio

app = Flask(__name__)
CORS(app)

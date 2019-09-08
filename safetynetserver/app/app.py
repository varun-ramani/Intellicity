from flask import Flask
from flask_cors import CORS
from flask_socketio import SocketIO, emit, Namespace

app = Flask(__name__)
CORS(app)

socketio = SocketIO(app)

if __name__ == '__main__':
    socketio.run(app)

@socketio.on('message', namespace='/socket')
def handle_message(message):
    emit('update', message, broadcast=True)

@socketio.on('connect', namespace='/socket')
def test_connect():
    emit('my response', {'data': 'Connected'})

@socketio.on('disconnect', namespace='/socket')
def test_disconnect():
    print('Client disconnected')
from flask import Flask
from flask_cors import CORS
from flask_socketio import SocketIO, emit, Namespace

app = Flask(__name__)
CORS(app)

socketio = SocketIO(app)

if __name__ == '__main__':
    socketio.run(app)

@socketio.on('message')
def handle_message(message):
    print(message)
    emit('update', message, broadcast=True)

@socketio.on('connect')
def test_connect():
    print('connect')
    # emit('my response', {'data': 'Connected'})

@socketio.on('disconnect')
def test_disconnect():
    print('Client disconnected')
from app import app
import routes
from flask_socketio import SocketIO, emit

socketio = SocketIO(app, cors_allowed_origins=[])

@socketio.on('message')
def handle_message(message):
    emit('message', {"hey": "hey"}, broadcast=True)


@socketio.on('connect')
def test_connect():
    print("Connected")


@socketio.on('disconnect')
def test_disconnect():
    print('Client disconnected')


if __name__ == "__main__":
    # app.run(debug=True, port=5000)
    socketio.run(app, debug=True, port=5000)

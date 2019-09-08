from app import app
import routes
from flask_socketio import SocketIO, emit

socketio = SocketIO(app)


@socketio.on('message', namespace='/live')
def handle_message(message):
    emit('message', message, broadcast=True, namespace = "/live")


@socketio.on('connect', namespace='/live')
def test_connect():
    print("Connected")


@socketio.on('disconnect', namespace='/live')
def test_disconnect():
    print('Client disconnected')


if __name__ == "__main__":
    # app.run(debug=True, port=5000)
    socketio.run(app, debug=True, port=5000)

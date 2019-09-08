from app import app
import routes
from flask_socketio import SocketIO, emit

socketio = SocketIO(app)

@socketio.on('message', namespace='/socket')
def handle_message(message):
    emit('message', message, broadcast=True)

@socketio.on('connect', namespace='/socket')
def test_connect():
    emit('my response', {'data': 'Connected'})

@socketio.on('disconnect', namespace='/socket')
def test_disconnect():
    print('Client disconnected')

if __name__ == "__main__":
    # app.run(debug=True, port=5000)
    socketio.run(app, debug=True, port=5000)



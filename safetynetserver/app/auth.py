from database import users
import jwt
from flask_bcrypt import Bcrypt
from app import app
from config import secret_key

bcrypt = Bcrypt(app)

def get_user_by_email(email):
    return users.find_one({"email": email})

def generate_jwt(email):
    print(email)
    return jwt.encode(dict({'email': email}), secret_key, algorithm='HS256')

def decode_jwt(authtoken):
    return jwt.decode(authtoken, secret_key)

def register_user(email, password):
    user = {
        "email": email,
        "password": bcrypt.generate_password_hash(password).decode('utf-8')
    }

    if get_user_by_email(email) != None:
        return None

    users.insert_one(user)
    return generate_jwt(email).decode('utf-8')

def authenticate_user(email, password):
    user = get_user_by_email(email)
    if user == None:
        return None
    elif bcrypt.check_password_hash(user['password'].encode('utf-8'), password) == False:
        return None
    return generate_jwt(email).decode('utf-8')

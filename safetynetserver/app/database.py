from pymongo import MongoClient

database = MongoClient()['safetynetdb']

users = database['users']
places = database['places']
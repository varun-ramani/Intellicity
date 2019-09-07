from pymongo import MongoClient
from bson.json_util import dumps
from bson.objectid import ObjectId

database = MongoClient('35.224.43.169', 27017)['safetynetdb']

users = database['users']
places = database['places']


def add(report):
    reports = database.reports
    report_id = reports.insert_one(report).inserted_id
    return report_id


def retrieve(ulat, llat, ulong, llong):
    data = dumps(database.reports.find({'latitude': {'$gt': llat}, 'latitude': {'$lt': ulat},  'longitude': {
                 '$gt': llong}, 'longitude': {'$lt': ulong}}, {'email': 1, 'longitude': 1, 'latitude': 1, 'description': 1, 'tags': 1}))
    return data


def get_image(objectid):
    return dumps(database.reports.find({'_id': ObjectId(objectid)}, {'image': 1}))

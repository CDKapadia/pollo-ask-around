'''
    database stuff
'''

from flask_sqlalchemy import SQLAlchemy
from server import app

db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'
    uid = db.Column(db.Integer, primary_key=True)
    uuid = db.Column(db.String(36), unique=True)

    '''
        id auto incremenents for db, uuid is the unique identifier for each device
    '''
    def __init__(self, uuid):
        self.uuid = uuid

    def __repr__(self):
        return "<User: %s>" % self.uuid

'''
    database stuff
'''

from flask_sqlalchemy import SQLAlchemy
from server import app
from server.utils import haversine
from sqlalchemy.ext.hybrid import hybrid_property, hybrid_method
from sqlalchemy import func

db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'

    uid = db.Column(db.Integer, primary_key=True)

    # unique device indentifier
    uuid = db.Column(db.String(36), unique=True, nullable=False)

    def __init__(self, uuid):
        self.uuid = uuid

    def __repr__(self):
        return "<User: %s>" % self.uuid

class Post(db.Model):
    __tablename__ = 'posts'

    pid = db.Column(db.Integer, primary_key=True)
    lat = db.Column(db.Float, nullable=False)
    lng = db.Column(db.Float, nullable=False)
    question = db.Column(db.String(100), nullable=False)

    # author of the post
    uid = db.Column(db.Integer, db.ForeignKey('users.uid'), nullable=False)
    author = db.relationship('User', backref=db.backref('posts', lazy='dynamic'))

    def __init__(self, question, lat, lng, author):
        self.question = question
        self.lat = lat
        self.lng = lng
        self.author = author

    def __repr__(self):
        return '<Post: %s>' % self.question

    @hybrid_method
    def distance(self, other):
        return haversine(self.lng, self.lat, other.lng, other.lat)

    @distance.expression
    def distance(cls, other):
        # convert measurements to radians
        lng1, lat1, lng2, lat2 = (cls.radians(angle) for angle in [cls.lng, cls.lat, other.lng, other.lat])
        # haversine formula
        dlng = lng2 - lng1
        dlat = lat2 - lat1
        a = func.pow(func.sin(dlat/2), 2) + func.cos(lat1) * func.cos(lat2) * func.pow(func.sin(dlng/2), 2)
        c = 2 * func.asin(func.sqrt(a))
        km = 6367 * c
        return km

    @staticmethod
    def radians(deg):
        '''for use with sql column datatypes'''
        return deg * func.pi() / 180


class Option(db.Model):
    __tablename__ = 'options'

    oid = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.String(50), nullable=False)
    votes = db.Column(db.Integer, nullable=False)

    pid = db.Column(db.Integer, db.ForeignKey('posts.pid'), nullable=False)
    post = db.relationship('Post', backref=db.backref('options', lazy='dynamic'))

    def __init__(self, text, pid, votes=0):
        self.text = text
        self.pid = pid
        self.votes = votes

    def __repr__(self):
        return '<Post Option: %i, %s, votes: %i>' % self.pid, self.text, self.votes

class Voted(db.Model):
    __tablename__ = 'voted'

    # tracks which users have voted on which questions
    vid = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.Integer, nullable=False)
    pid = db.Column(db.Integer, nullable=False)

    def __init__(self, uid, pid):
        self.uid = uid
        self.pid = pid

    def __repr__(self):
        return '<Vote uid: %i, pid: %i>' % self.uid, self.pid

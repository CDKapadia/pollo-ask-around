'''
    database stuff
'''

from flask_sqlalchemy import SQLAlchemy
from server import app

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
    __tablename__ = "posts"

    pid = db.Column(db.Integer, primary_key=True)
    lat = db.Column(db.DECIMAL, nullable=False)
    lng = db.Column(db.DECIMAL, nullable=False)
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

class Option(db.Model):
    __tablename__ = "options"

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

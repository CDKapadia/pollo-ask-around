'''
    views file that defines behavior for each webppage
'''
import json
from flask import request
from server import app
from server.models import db, User
import sqlalchemy.exc

db.create_all()

@app.route('/')
def index():
    return "Hello, World!<br>Kevin sucks"

@app.route('/init_user')
def init_user():
    response = {}
    uuid = request.args.get('uuid')
    user = User(uuid)
    try:
        db.session.add(user)
        db.session.commit()
        response['message'] = 'created'
    except sqlalchemy.exc.IntegrityError:
        response['message'] = 'uuid exists'
    except:
        response['message'] = 'db error'
    return json.dumps(response)

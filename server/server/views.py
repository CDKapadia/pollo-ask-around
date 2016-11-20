'''
    views file that defines behavior for each webppage
'''
import json
import ast
from flask import request
from server import app
from server.models import db, User, Post, Option
import sqlalchemy.exc

db.create_all()


@app.route('/')
def index():
    return "Hello, World!<br>Kevin sucks"


@app.route('/init_user')
def init_user():
    response = {}
    uuid = request.args.get('uuid')
    if uuid is None:
        response['message'] = 'no uuid provided'
    else:
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


@app.route('/create_post', methods=['POST'])
def create_post():
    required_args = ['question', 'lat', 'lng', 'uuid', 'options']
    passed_params = {}
    response = {}

    for key in requiredargs:
        passed_params[key] = request.form.get('key', None)

    # check that all required parameters were passed
    if any(pased_params[key] is None for key in required_args):
        response['message'] = "not all parameters were passed"
    else:
        try:
            passed_params['options'] = ast.literal_eval(passed_params['options'])
        except:
            response['message'] = 'options were not passed correctly'
        else:
            user = User.query.filter_by(uuid=passed_params['uuid']).first()
            post = Post(passed_params['question'], passed_params['lat'], passed_params['lng'], user)
            db.session.add(post)
            db.session.commit()
        return json.dumps(response)

@app.route('/test')
def test():
    user = User.query.filter_by(uuid='hri1o2jd-uto1-74jd-pqjfoe1g0315').first()
    print(user)
    print(user.posts.all())
    print(request.form)
    return 'test'

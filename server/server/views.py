'''
    views file that defines behavior for each webppage
'''
import ast
from flask import request, make_response, jsonify
from server import app
from server.models import db, User, Post, Option
import sqlalchemy.exc

db.create_all()


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


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
    return jsonify(response)


@app.route('/create_post', methods=['POST'])
def create_post():
    required_args = ['q', 'lat', 'lng', 'uuid', 'options']
    passed_params = {}
    response = {}

    # get all arguments from post
    for key in required_args:
        passed_params[key] = request.form.get(key, None)

    # check that all required parameters were passed
    if any(passed_params[key] is None for key in required_args):
        response['message'] = "not all parameters were passed"
    else:
        try:
            options = ast.literal_eval(passed_params['options'])
        except:
            response['error'] = 'options were not passed correctly'
        else:
            try:
                user = User.query.filter_by(uuid=passed_params['uuid']).first()
                post = Post(passed_params['q'], passed_params['lat'], passed_params['lng'], user)

                db.session.add(post)
                db.session.flush()

                for option in options:
                    db.session.add(Option(option, post.pid))

                response['error'] = 'post created'
                db.session.commit()
            except:
                response['error'] = 'user with id %s not found' % passed_params['uuid']
    return jsonify(response)


@app.route('/posts', methods=['GET'])
def posts():
    args = ['uuid', 'lat', 'lng', 'radius']

@app.route('/test')
def test():
    user = User.query.filter_by(uuid='hri1o2jd-uto1-74jd-pqjfoe1g0315').first()
    print(user)
    print(user.posts.all())
    print(request.form)
    return 'test'

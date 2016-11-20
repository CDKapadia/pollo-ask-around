'''
    views file that defines behavior for each webppage
'''
import ast
from flask import request, make_response, jsonify, abort
from server import app
from server.models import db, User, Post, Option
from server.utils import haversine
import sqlalchemy.exc

db.create_all()


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


@app.errorhandler(400)
def bad_request(error):
    return make_response(jsonify({'error': 'Bad Request'}), 400)


@app.errorhandler(500)
def internal_error(error):
    return make_response(jsonify({'error': 'Internal Servor Error'}), 500)


@app.route('/user/<uuid>', methods=['GET'])
def get_user(uuid):
    response = {}
    user = User.query.filter_by(uuid=uuid).first()
    if user:
        response['user'] = user.uid
    else:
        abort(404)
    return jsonify(response)

# create user
@app.route('/user', methods=['POST'])
def create_user():
    response = {}
    uuid = request.form.get('uuid')
    if uuid is None:
        abort(400)
    else:
        user = User(uuid)
        try:
            db.session.add(user)
            db.session.commit()
            response['message'] = 'created'
        except sqlalchemy.exc.IntegrityError:
            abort(400)
        except:
            abort(500)
    return jsonify(response), 201


@app.route('/user/<uuid>/post', methods=['GET'])
def get_posts_by_user(uuid):
    response = {}
    user = User.query.filter_by(uuid=uuid).first()

    if user is None:
        abort(400)

    posts = user.posts.all()
    for i, post in enumerate(posts):
        options = Option.query.filter_by(pid=post.pid).all()
        response[i] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': uuid,
                'options': [option.text for option in options]
        }
    return jsonify(response)


@app.route('/post/@<lat>,<lng>', methods=['GET'])
def get_posts_by_location(lat, lng):
    # default radius if one is not specif
    radius = request.args.get('r', 5)
    lat = float(lat)
    lng = float(lng)
    # this can be optimized but i don't know the syntax
    posts = Post.query.all()
    posts = [post for post in posts if haversine(lng, lat, post.lng, post.lat) < radius]
    response = {}
    for i, post in enumerate(posts):
        options = Option.query.filter_by(pid=post.pid).all()
        author = User.query.filter_by(uid=post.uid).first()
        response[i] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': author.uuid,
                'options': [option.text for option in options]
        }
    return jsonify(response)


@app.route('/post', methods=['POST'])
def create_post():
    required_args = ['q', 'lat', 'lng', 'uuid', 'options']
    passed_params = {}
    response = {}

    # get all arguments from post
    for key in required_args:
        passed_params[key] = request.form.get(key, None)

    # check that all required parameters were passed
    if any(passed_params[key] is None for key in required_args):
        abort(400)
    else:
        try:
            options = ast.literal_eval(passed_params['options'])
        except:
            abort(400)
        else:
            try:
                user = User.query.filter_by(uuid=passed_params['uuid']).first()
                post = Post(passed_params['q'], passed_params['lat'], passed_params['lng'], user)

                db.session.add(post)
                db.session.flush()

                for option in options:
                    db.session.add(Option(option, post.pid))

                db.session.commit()
                response['message'] = 'post created'
            except:
                abort(400)
    return jsonify(response), 201


@app.route('/test/')
def test():
    print(request.args.get('q'))
    return 'test'

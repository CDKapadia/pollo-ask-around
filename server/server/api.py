'''
    views file that defines behavior for each webppage
'''
import ast
from flask import request, make_response, jsonify, abort
from server import app
from server.models import db, User, Post, Option, Vote
import sqlalchemy.exc
import json

db.create_all()


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': error.description}), 404)


@app.errorhandler(400)
def bad_request(error):
    return make_response(jsonify({'error': error.description}), 400)


@app.errorhandler(409)
def already_exists(error):
    return make_response(jsonify({'error': error.description}), 409)


@app.errorhandler(500)
def internal_error(error):
    return make_response(jsonify({'error': 'internal server error'}), 500)


@app.route('/users/<uuid>', methods=['GET'])
def get_user(uuid):
    response = {}
    user = User.query.filter_by(uuid=uuid).first()
    if user:
        response['user'] = user.uid
    else:
        # return jsonify({'test':'test'}), 200
        abort(404, 'user with id %s not found' % uuid)
    return jsonify(response)


@app.route('/users', methods=['POST'])
def create_user():
    response = {}
    uuid = request.form.get('uuid')
    if uuid is None:
        abort(404, 'no uuid entered')
    else:
        user = User(uuid)
        try:
            db.session.add(user)
            db.session.commit()
            response['message'] = 'created'
        except sqlalchemy.exc.IntegrityError:
            abort(409, 'uuid already exists')
        except:
            abort(500, 'Internal server error')
    return jsonify(response)


@app.route('/users/<uuid>/posts', methods=['GET'])
def get_posts_by_user(uuid):
    user = User.query.filter_by(uuid=uuid).first()

    if user is None:
        abort(404, 'user with uuid %s not found' % uuid)

    results_per_page = 10
    # start on page 0 by default
    try:
        page = int(request.args.get('page', 0))
    except ValueError:
        abort(400, 'page was not a number')

    posts = user.posts[page * results_per_page: (page + 1) * results_per_page]
    response = {}
    for post in posts:
        # options = Option.query.filter_by(pid=post.pid).all()
        response[post.pid] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': uuid
                #'options': {option.oid: {'votes': option.votes, 'text': option.text} for option in options}
        }
    return jsonify(response)


@app.route('/posts/@<lat>,<lng>', methods=['GET'])
def get_posts_by_location(lat, lng):
    # default radius if one is not specified
    radius = request.args.get('r', 5)

    try:
        # dummy Post object with location for use with filter
        curr = Post("", float(lat), float(lng), User(""))

        # default page 0
        page = int(request.args.get('page', 0))
    except ValueError:
        abort(400, 'please enter decimals for lat and long')

    results_per_page = 10

    posts = Post.query.filter(Post.distance(curr) < 5)[page * results_per_page: (page + 1) * results_per_page]
    response = {}
    for post in posts:
        # options = Option.query.filter_by(pid=post.pid).all()
        author = User.query.filter_by(uid=post.uid).first()
        response[post.pid] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': author.uuid
                #'options': {option.oid: {'votes': option.votes, 'text': option.text} for option in options}
        }
    return jsonify(response)


@app.route('/posts', methods=['POST'])
def create_post():
    required_args = ['q', 'lat', 'lng', 'uuid', 'options']
    passed_params = {}
    response = {}

    # get all arguments from post
    for key in required_args:
        passed_params[key] = request.form.get(key, None)

    if any(passed_params[key] is None for key in required_args):
        # not all parameters were passed
        abort(400, 'missing parameter')

    try:
        options = ast.literal_eval(passed_params['options'])
    except SyntaxError:
        abort(400, 'error parsing options')

    user = User.query.filter_by(uuid=passed_params['uuid']).first()

    if user is None:
        abort(404, 'could not find user with uuid %s' % uuid)

    post = Post(passed_params['q'], passed_params['lat'], passed_params['lng'], user)

    db.session.add(post)
    db.session.flush()

    for option in options:
        db.session.add(Option(option, post.pid))

    db.session.commit()
    response['message'] = 'post created'
    return jsonify(response)


@app.route('/posts', methods=['DELETE'])
def delete_post():
    # TODO: implementation
    pid = request.form.get('pid')
    post = Post.query.filter_by(pid=pid).first()
    if post is None:
        abort(404, 'post with pid %s not found' % pid)

    db.session.delete(post)
    db.session.commit()
    return jsonify({'message': 'post deleted'})


@app.route('/posts/<int:pid>/options', methods=['GET'])
def get_votes(pid):
    post = Post.query.filter_by(pid=pid).first()
    if post is None:
        abort(404, 'post with pid %s not found' % pid)
    response = {option.oid: {'text': option.text, 'votes': option.votes} for option in post.options}
    return jsonify(response)


@app.route('/posts/<int:pid>/votes/users/<uuid>', methods=['GET'])
def get_votes_from_user(pid, uuid):
    vote = Vote.query.filter_by(pid=pid, uuid=uuid).first()
    response = {}
    if vote is None:
        response['voted'] = False
    else:
        response['voted'] = True
        response['oid'] = vote.oid
    return jsonify(response)


@app.route('/options/<int:oid>', methods=['PATCH'])
def change_vote(oid):
    data = json.loads(request.data.decode('utf-8'))
    uuid = data.get('uuid')

    user = User.query.filter_by(uuid=uuid).first()
    if user is None:
        print(uuid)
        abort(404, 'user with uuid %s not found' % uuid)

    option = Option.query.filter_by(oid=oid).first()
    if option is None:
        abort(404, 'option with oid %s not found' % oid)

    operation = data.get('op')
    if operation is None:
        abort(400, 'no operation specified')

    if operation == 'add':
        option.votes += 1
    elif operation == 'remove':
        option.votes -= 1
    else:
        abort(400, 'not valid operation')

    vote = Vote(uuid, option.pid, oid)

    db.session.add(vote)
    db.session.commit()
    response = {'message': 'voted'}
    return jsonify(response)


@app.route('/test/')
def test():
    print(request.args.get('q'))
    return 'test'

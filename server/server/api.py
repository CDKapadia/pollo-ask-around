'''
    views file that defines behavior for each webppage
'''
import ast
from flask import request, make_response, jsonify, abort
from server import app
from server.models import db, User, Post, Option
import sqlalchemy.exc

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
    return jsonify(response), 201


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
    for i, post in enumerate(posts):
        options = Option.query.filter_by(pid=post.pid).all()
        response[i] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': uuid,
                'options': {option.oid: {'votes': option.votes, 'text': option.text} for option in options}
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
    for i, post in enumerate(posts):
        options = Option.query.filter_by(pid=post.pid).all()
        author = User.query.filter_by(uid=post.uid).first()
        response[i] = {
                'q': post.question,
                'lat': float(post.lat),
                'lng': float(post.lng),
                'author': author.uuid,
                'options': {option.oid: {'votes': option.votes, 'text': option.text} for option in options}
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
        user = User.query.filter_by(uuid=passed_params['uuid']).first()
        post = Post(passed_params['q'], passed_params['lat'], passed_params['lng'], user)

        db.session.add(post)
        db.session.flush()

        for option in options:
            db.session.add(Option(option, post.pid))

        db.session.commit()
        response['message'] = 'post created'
    except SyntaxError:
        abort(400, 'error parsing options')
    except AttributeError:
        abort(404, 'could not find user with uuid %s' % uuid)
    return jsonify(response), 201


@app.route('/posts', methods=['DELETE'])
def delete_post():
    # TODO: implementation
    pass

@app.route('/votes/<int:oid>', methods=['PATCH'])
def vote(oid):
    # TODO: validate that user has not voted already
    try:
        op = request.form['op']
        uuid = request.form['uuid']
        pid = request.form['pid']
        user = User.query.filter_by(uuid=uuid).first()
        option = Option.query.filter_by(oid=oid).first()
        if op == 'add':
            option.votes += 1
        elif op == 'remove':
            option.votes -= 1
        else:
            raise ValueError()
        db.commit()
    except KeyError:
        abort(400, 'no operation specified')
    except ValueError:
        abort(400, 'not valid operation')
    except AttributeError:
        abort(404, 'option with id %i not found' % oid)


@app.route('/test/')
def test():
    print(request.args.get('q'))
    return 'test'

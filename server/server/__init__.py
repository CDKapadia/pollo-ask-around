'''
    interface for server package
'''

from flask import Flask

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/final438'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

# needed to run views logic when only importing package name from the outside
import server.api

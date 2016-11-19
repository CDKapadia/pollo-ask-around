'''
    interface for server package
'''

from flask import Flask

app = Flask(__name__)

# needed to run views logic when only importing package name from the outside
import server.views

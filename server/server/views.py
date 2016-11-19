'''
    views file that defines behavior for each webppage
'''

from server import app

@app.route('/')
def index():
    return "Hello, World!<br>Kevin sucks"

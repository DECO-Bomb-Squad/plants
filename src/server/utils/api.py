import os

from typing import Callable
from data import DB
from flask import request
from dotenv import load_dotenv
from sqlalchemy.orm import close_all_sessions

'''
Decorator function for creating an 
individualised session per API call.

Usage:
@app.route('/example')
@APICall
def example_thingo(session):
    pass

'''
def APICall(func: Callable):
    def inner(*args, **kwargs):
        session = DB.SESSION()
        try:
            res = func(session, *args, **kwargs)
        finally:
            session.close()
            close_all_sessions()
        return res
    inner.__name__ = func.__name__
    return inner

def is_valid_key(key):
    load_dotenv()
    API_KEY = os.getenv('API_KEY')
    return key == API_KEY

'''
Decorator function for authenticating requests with an API key.
@param func: flask function
'''
def api_auth(func: Callable):
    def inner_auth(*args, **kwargs):
        api_key = request.headers.get('apiKey')
        
        if is_valid_key(api_key):
            return func(*args, **kwargs)
        else:
            return "Forbidden. The given API key is invalid", 403
    inner_auth.__name__ = func.__name__
    return inner_auth
        
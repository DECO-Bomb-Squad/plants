from typing import Callable
from data import DB

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
        res = func(session, *args, **kwargs)
        return res
    inner.__name__ = func.__name__
    return inner
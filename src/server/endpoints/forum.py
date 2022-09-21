from typing import List
from flask import Blueprint,request
from data import Plant, User, PlantType, PlantCareProfile, PlantCareProfileDefault, Activity, ActivityType, Tag, PlantTag, Photo, Post, Comment, PostPlant, PostTag
import json
from utils.api import APICall
from flask import jsonify

app = Blueprint('forum_endpoints', __name__)
# session = DB.SESSION()

# ===== Major User Endpoints ====

'''
Adds a post (POST (lol))
    - Params:
        - userId:  int
        - title:   string
        - content: string
'''
@app.route("/forum/post", methods = ['POST'])
@APICall
def add_post(session):
    try:
        userId:   int = request.form['userId']
        title:    str = request.form['title']
        content:  str = request.form['content']
        #plants: list(int) plant ids (for later cuz this is hard)
        #tags: list(str) tags?

        # verify information
        if (not userId or not title or not content):
            raise KeyError

        # check user exists
        print('userId: ' + userId)
        userCount: int = session.query(User).filter(User.id == userId).count()
        print('user count: ' + userCount)
        user = session.query(User).filter(User.id == userId).first()
        print('test3')
        if (not user):
            return 'Could not find user with id = %s' %userId, 400

    except KeyError as e:
        return "To add a post, you must provide: userId: int, title: str, content: str", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # add to database
    try:
        print('test2')
        newPost = Post(title=title, content=content, userId=userId)
        session.add(newPost)
        session.commit()
    except Exception as e:
        print("An unknown error occurred:", e)

    return 'The post was added successfully', 200


from typing import List
from flask import Blueprint,request
from data import Plant, User, PlantType, PlantCareProfile, PlantCareProfileDefault, Activity, ActivityType, Tag, PlantTag, Photo, Post, Comment, PostPlant, PostTag
import json
from utils.api import APICall, api_auth
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
@api_auth
def add_post(session):
    try:
        userId:   int = request.form['userId']
        title:    str = request.form['title']
        content:  str = request.form['content']
        plantIds:   str = request.form['plantIds'] # encoded in JSON.
        #tags: list(str) tags?

        # verify information
        if (not userId or not title or not content or not plantIds):
            raise KeyError

        parsedPlantIds = json.loads(plantIds)
        # this is munted, I think it's to do with json.loads
        # if not isinstance(parsedPlantIds, list):
        #     print("OI")
        #     raise TypeError

        # check if all the plants exist
        for plantId in parsedPlantIds:
            plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()
            if not plant:
                return f"One of the plant ids given [{plantId}] could not be found", 400

        # check if user exists
        user: User = session.query(User).filter(User.id == userId).first()
        if (not user):
            return 'Could not find user with id = %s' %userId, 400

    except TypeError as e:
            return "Invalid format. Please give as a list, i.e.: [1, 2, 3, ...]", 400
    except KeyError as e:
        return "To add a post, you must provide: userId: int, title: str, content: str, plantIds: [str]", 400
    except Exception as e:
        return "An unknown error occurred:", e, 500

    # add to database
    try:
        # Post
        newPost = Post(title=title, content=content, userId=int(userId))
        session.add(newPost)
        session.flush()
        session.refresh(plant)
        # Post Plants
        for plantId in parsedPlantIds:
            postPlant = PostPlant(plantId, newPost.id)
            session.add(postPlant)
        session.commit()
    except Exception as e:
        print("An unknown error occurred:", e)

    return 'The post was added successfully', 200


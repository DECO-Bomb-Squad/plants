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
        - plantIds: [str]
        - tagIds: [str]
'''
@app.route("/forum/post", methods = ['POST'])
@APICall
@api_auth
def add_post(session):
    try:
        userId:   int = request.form['userId']
        title:    str = request.form['title']
        content:  str = request.form['content']
        plantIds: str = request.form['plantIds'] # encoded in JSON.
        tags:     str = request.form['tagIds'] # encoded in JSON

        # verify information
        if (not userId or not title or not content or not plantIds or not tags):
            raise KeyError

        parsedTags = json.loads(tags)
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

        # check if all the tags exist
        for tagId in parsedTags:
            tag: Tag = session.query(Tag).filter(Tag.id == tagId).first()
            if not tag:
                return f"One of the tag ids given [{tagId}] could not be found", 400

        # check if user exists
        user: User = session.query(User).filter(User.id == userId).first()
        if (not user):
            return 'Could not find user with id = %s' %userId, 400

    except TypeError as e:
            return "Invalid format. Please give as a list, i.e.: [1, 2, 3, ...]", 400
    except KeyError as e:
        return "To add a post, you must provide: userId: int, title: str, content: str, plantIds: [str], tagIds: [str].\nEven if you're not adding anything to plantIds and tagIds, please provide an empty list.", 400
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
        # Post Tags
        for tagId in parsedTags:
            postTag = PostTag(newPost.id, tagId)
            session.add(postTag)
        session.commit()
    except Exception as e:
        print("An unknown error occurred:", e)

    return 'The post was added successfully', 200

'''
Adds a comment to a post (POST)
    - Params
        - postId: int
        - content: string
        - parentId: int (OPTIONAL)
        - userId: int
'''
@app.route("/forum/comment", methods=["POST"])
@APICall
@api_auth
def add_comment(session):
    try:
        userId:   int = request.form['userId']
        content:  str = request.form['content']
        parentId: int = request.form.get('parentId') # this will silently fail, since it's optional
        postId:   int = request.form['postId'] # encoded in JSON

        # check if all is good
        if (not userId or
            not content or
            not postId):
            raise KeyError

        # confirm the existence of the post
        post: Post = session.query(Post).filter(Post.id == postId).first()
        if not post:
            return f"The post with id [{postId}] could not be found", 400

        # confirm the existence of the user
        user: User = session.query(User).filter(User.id == userId).first()
        if not user:
            return f"The user with id [{userId}] could not be found", 400

        # if the user has given a parentId, check if that comment exists
        if parentId:
            parent: Comment = session.query(Comment).filter(Comment.id == parentId).first()
            if not parent:
                return f"The parent comment does not exist with id [{parentId}]", 400

    except KeyError as e:
        return "Invalid request. NEED to provide userId: int, postId: int, content: str. OPTIONALLY include parentId: int.", 400
    except Exception as e:
        return f"An error occurred: {e}", 500

    try:
        comment: Comment = Comment(content, userId, postId, parentId)
        session.add(comment)
        session.commit()
    except Exception as e:
        return f"An unknown exception occurred: {e}", 500

    return "The comment was added successfully", 200

@app.route("/forum/post/<id>", methods=["GET"])
@APICall
@api_auth
def get_post(session, id):
    # confirm the post exists
    post: Post = session.query(Post).filter(Post.id == id).first()
    if not post:
        return f"This post with id [{id}] does not exist.", 400

    return post.serialize(), 200
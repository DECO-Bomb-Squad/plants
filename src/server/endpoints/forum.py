from typing import List
from flask import Blueprint,request
from data import Plant, User, PlantType, PlantCareProfile, PlantCareProfileDefault, Activity, ActivityType, Tag, PlantTag, Photo, Post, Comment, PostPlant, PostTag
import json
from utils.api import APICall, api_auth
from flask import jsonify

app = Blueprint('forum_endpoints', __name__)

# ===== Major Forum Endpoints ====

'''
Adds a post (POST (lol))
    - Params:
        - userId:  int
        - title:   string
        - content: string
        - plantIds: [str]
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
        return "To add a post, you must provide: userId: int, title: str, content: str, plantIds: [str], tagIds: [str].\nEven if you're not adding anything to plantIds and tagIds, please provide an empty list.", 400
    except Exception as e:
        return "An unknown error occurred:", e, 500

    # add to database
    try:
        # Post
        newPost = Post(title=title, content=content, userId=int(userId))
        session.add(newPost)
        session.flush()
        session.refresh(newPost)
        # Post Plants
        for plantId in parsedPlantIds:
            postPlant = PostPlant(plantId, newPost.id)
            session.add(postPlant)

        session.commit()
    except Exception as e:
        print("An unknown error occurred:", e)

    return newPost.serialize(), 200

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
        careProfileId: int = request.form.get('careProfileId') # this will silently fail, since it's optional
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
        
        # if the user provides a care profile, check it exists:
        if careProfileId:
            careProfile: PlantCareProfile = session.query(PlantCareProfile).filter(PlantCareProfile.id == careProfileId).first()
            if not careProfile:
                return f"There is no plant care profile with id [{careProfileId}]", 400

    except KeyError as e:
        return "Invalid request. NEED to provide userId: int, postId: int, content: str. OPTIONALLY include parentId: int, careProfileId: int.", 400
    except Exception as e:
        return f"An error occurred: {e}", 500

    try:
        comment: Comment = Comment(content, userId, postId, parentId, careProfileId)
        session.add(comment)
        session.commit()
    except Exception as e:
        return f"An unknown exception occurred: {e}", 500

    return comment.serialize(), 200

'''
Gets information about a post (GET)
'''
@app.route("/forum/post/<id>", methods=["GET"])
@APICall
@api_auth
def get_post(session, id):
    # confirm the post exists
    post: Post = session.query(Post).filter(Post.id == id).first()
    if not post:
        return f"This post with id [{id}] does not exist.", 400

    return post.serialize(), 200


'''
Gets a list of most recently created posts (GET)
'''
@app.route("/forum/post/list/<num>", methods=["GET"])
@APICall
@api_auth
def get_post_list(session, num):
    #check num isn't fish
    if not num.isdecimal():
        return "Please specify a valid number at the end of this URL - this will limit the amount of records to that number.", 400

    # confirm the posts exist
    posts: Post = session.query(Post).order_by(Post.created.desc()).limit(num).all()


    if not posts:
        return f"Can't find posts", 400
    postlist = [post.id for post in posts]
    return jsonify(posts=postlist), 200

'''
Updates the score of a POST
    Requires:
        - postId: int
        - score: int
'''
@app.route('/forum/post/updatescore', methods=["PATCH"])
@APICall
@api_auth
def update_score(session):
    try:
        postId = request.form['postId']
        score  = request.form['score']

        post = session.query(Post).filter(Post.id == postId).first()
        if not post:
            return f"This post with id [{postId}] does not exist.", 400

    except KeyError as e:
        return "Needs postId: int, score: int"

    try:
        post.score = score
        session.commit()
    except Exception as e:
        return f"An unknown error occurred: {e}", 500
    
    return "Score updated successfully", 200

'''
Updates the score of a COMMENT
    Requires:
        - postId: int
        - score: int
'''
@app.route('/forum/comment/updatescore', methods=["PATCH"])
@APICall
@api_auth
def update_score_comment(session):
    try:
        commentId = request.form['commentId']
        score  = request.form['score']

        comment = session.query(Comment).filter(Comment.id == commentId).first()
        if not comment:
            return f"This post with id [{commentId}] does not exist.", 400

    except KeyError as e:
        return "Needs commentId: int, score: int"

    try:
        comment.score = score
        session.commit()
    except Exception as e:
        return f"An unknown error occurred: {e}", 500
    
    return f"Score updated successfully on comment id: [{commentId}]", 200
from typing import List, Optional
from flask import Blueprint,request
from sqlalchemy import update
from data import User
import json
from data.constants import TBL_USERS
from data.users.token import Token
from utils.api import APICall, api_auth
from flask import jsonify

app = Blueprint('user_endpoints', __name__)
# session = DB.SESSION()

# ===== Major User Endpoints ====

'''
Adds a User (POST)
    - Params:
        - username:  string
        - email:     string
'''
@app.route("/user", methods = ['POST'])
@APICall
@api_auth
def add_user(session):
    try:
        username: str = request.form['username']
        email:    str = request.form['email']

        # verify information
        if (not username or not email):
            raise KeyError

        # check if user / email already exists
        numUsers  = session.query(User).filter(User.username == username).count()
        numEmails = session.query(User).filter(User.email == email).count()
        if numUsers > 0 or numEmails > 0:
            return "This user and/or email already exists.", 400

    except KeyError as e:
        return "To add a user, you must provide: username: str, email: str", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # add to database
    try:
        user = User(username=username, email=email)
        session.add(user)
        session.commit()
    except Exception as e:
        print("An unknown error occurred:", e)

    return 'The user was added successfully', 200

'''
Gets ALL Users (GET)
    - Returns:
        List of usernames and their ids
'''
@app.route("/users/", methods = ['GET', 'POST'])
@APICall
@api_auth
def get_all_users(sesh):
    users: List[User] = sesh.query(User).all()
    allUsers = [user.serialize() for user in users]
    return jsonify(users=allUsers)

'''
Gets a User (GET)
    - Params:
        - userId: int
    - Returns:
        - all user info
'''
@app.route("/users/<username>", methods = ['GET', 'POST'])
@APICall
@api_auth
def get_user(session, username: str):
    user: User = session.query(User).filter(User.username == username).first()
    if user:
        return user.serialize(), 200
    else:
        return "The user was not found", 400

'''
Gets a Users Plants (GET)
    - Params:
        - userId: int
    - Returns:
        - ids of a user's plants
'''
@app.route("/users/<username>/plants", methods = ["GET", "POST"])
@APICall
@api_auth
def get_user_plants(session, username: str):
    user: User = session.query(User).filter(User.username == username).first()

    if not user:
        return "User not found. This requires username: str", 400

    try:
        userPlants = user.get_plants()
    except Exception as e:
        return "An error occured whilst retrieving user plant information", e, 500
    
    return userPlants, 200

    

# === Minor User Endpoints ====

'''
Set User Bio
    - Params:
        - username: string
        - bio:      string
'''
@app.route("/users/setbio", methods = ['POST'])
@APICall
@api_auth
def set_user_bio(session):
    try:
        username: str = request.form['username']
        bio:      str = request.form['bio']

        # verify information
        if (not username or not bio):
            raise KeyError

        # check if user exists
        numUsers  = session.query(User).filter(User.username == username).count()
        if numUsers == 0:
            return "This user could not be found.", 400

    except KeyError as e:
        return "To set a user's bio, you must provide: username: str, bio: str", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    try:
        session.query(User).filter(User.username == username).update({'bio': bio})
        session.commit()
    except Exception as e:
        return "There was an error updating the entry:", e, 400

    return "The bio was updated successfully", 200

'''
Add user token
    - Params:
        -token: string
'''
@app.route("/users/<username>/token", methods=["POST"])
@APICall
@api_auth
def add_token(session, username: str):
    user: User = session.query(User).filter(User.username == username).first()
    if user is None:
        return "User not found", 404
    try:
        token: str = request.form['token']

        if token is None:
            raise KeyError
    except KeyError as e:
        return "To add a user's token, you must provide: token: str", 400
    
    existing_token: Optional[Token] = session.query(Token) \
        .filter(Token.userId == user.id) \
        .filter(Token.token == token) \
        .first()
    
    if (existing_token is not None):
        # Don't need to add new token object, but still a success
        return "Token already exists - up to date", 200
    
    try:
        new_token: Token = Token(user.id, token)
        session.add(new_token)
        session.commit()
    except Exception as e:
        return f"Error adding new token to database: {e}", 500
    
    return "Successfully added user token", 200

from flask import Blueprint,request
from sqlalchemy import update
from data import DB, User
import json
from data.constants import TBL_USERS

app = Blueprint('user_endpoints', __name__)
session = DB.SESSION()

# ===== Major User Endpoints ====

'''
Adds a User (POST)
    - Params:
        - username:  string
        - email:     string
'''
@app.route("/user", methods = ['POST'])
def add_user():
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
def get_all_users():
    users = session.query(User).all()
    res = json.dumps(list(map(lambda user : {"username": user.username, "id": user.id}, users)))
    return res, 200

'''
Gets a User (GET)
    - Params:
        - userId: int
    - Returns:
        - all user info
'''
@app.route("/users/<username>", methods = ['GET', 'POST'])
def get_user(username: str):
    user: User = session.query(User).filter(User.username == username).first()
    if user:
        return {
            "userId": user.id,
            "username": user.username,
            "email": user.email,
            "startDate": user.startDate,
            "reputation": user.reputation,
            "bio": user.bio if user.bio else ""
        }, 200
    else:
        return "The user was not found", 400

# === Minor User Endpoints ====

'''
Set User Bio
    - Params:
        - username: string
        - bio:      string
'''
@app.route("/users/setbio", methods = ['POST'])
def set_user_bio():
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
from flask import Blueprint,request
from data import DB, User

app = Blueprint('user_endpoints', __name__)
session = DB.SESSION()

# ===== Major User Endpoints ====

@app.route("/")
def root():
    return "Welcome to our friendly Plants API. Check the Docs."

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
Gets a User (GET)
    - Params:
        - userId: int
    - Returns:
        - all user info
'''
@app.route("/users/<username>", methods = ['GET', 'POST'])
def get_user(username: str):
    pass

# === Minor User Endpoints ====

'''
Set User Bio
    - Params:
        - userId:   int
        - bio:      string
'''
@app.route("/users/setbio")
def set_user_bio():
    pass
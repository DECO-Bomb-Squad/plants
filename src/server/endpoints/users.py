from flask import Blueprint

app = Blueprint('user_endpoints', __name__)

# ===== Major User Endpoints ====

'''
Adds a User (POST)
    - Params:
        - username:  string
        - email:     string
        - startDate: date
'''
@app.route("/users/add")
def add_user():
    return '<p>Hello!!</p>'

'''
Gets a User (GET)
    - Params:
        - userId: int
    - Returns:
        - all user info
'''
@app.route("/users/<username>")
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
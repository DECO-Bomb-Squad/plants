from flask import Blueprint, request
from data import Plant, User, PlantType
from utils.api import APICall

import json


app = Blueprint('plant_endpoints', __name__)

# ===== Personal Plant Management Endpoints ====

'''
Adds a PERSONAL plant. (POST)
    - Params: 
        - personalName:  string  
        - desc:          string
        - userId:        int
        - photoUrl:      string 
        - plantTypeId:   int
        - plantTags:     [string]
'''
@app.route("/plant", methods = ["POST"])
# TODO:
#  - Photo saving to Azure
#  - Plant Tags
@APICall
def add_personal_plant(session):
    try:
        personalName: str = request.form['personalName']
        description:  str = request.form['desc']
        userId:       int = request.form['userId']
        # photoUrl:     str = request.form['photoUrl']
        plantTypeId:  int = request.form['plantTypeId']
        # plantTags:    List[str] = request.form['plantTags']

        # verify all information is present
        if (not userId or
            not personalName or
            not description or
            # not photoUrl or
            not plantTypeId):
            # not plantTags):
            raise KeyError

        # foreign key check
        userCount: int = session.query(User).filter(User.id == userId).count()
        typeCount: int = session.query(PlantType).filter(PlantType.id == plantTypeId).count()
        if (userCount == 0 or typeCount == 0):
            return "Invalid user or plant type information", 400

    except KeyError as e:
        return "To add a plant, you must provide: personalName: str, description: str, userId: str, photoUrl: str, plantTypeId: str, plantTags: [str]", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # add to DB
    try:
        plant = Plant(name=personalName, desc=description, plantTypeId=plantTypeId, userId=userId)
        session.add(plant)
        session.commit()
    except Exception as e:
        return "A database error occurred:", e, 400

    return "The plant was added successfully", 200

'''
Gets a PERSONAL Plant (GET)
    - Params:
        - plantId: int and/or username: string
    - Returns:
        - all plant information
'''
@app.route("/plant/<id>", methods = ["GET"])
@APICall
def get_personal_plant(session, id: str):
    # verify the id
    plant: Plant = session.query(Plant).filter(Plant.id == id).first()
    if not plant:
        return "The requested plant does not exist", 400

    # return information about the plant
    return plant.serialize(), 200

'''
Deletes a PERSONAL Plant (DELETE)
    - Params:
        - plantId: int
    
    ASSUME THE USER IS DELETING THEIR AND NOT SOMEONE ELSES PLANT
'''
@app.route('/plants/delete', methods = ['DELETE'])
@APICall
def delete_personal_plant(session):
    try:
        plantId: str = request.form['plantId']
    except KeyError:
        return "Invalid request parameters. Must include plantId: str", 400

    # check it's in the DB
    plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()
    if not plant:
        return "Plant was not found", 400

    # attempt a deletion
    try:
        session.delete(plant)
        session.commit()
    except Exception as e:
        return "Error deleting plant:", e, 500

    return "Plant was successfully deleted", 200

# ==== Miscellaneous Plant Endpoints ====

'''
Adds an Activity to a Plant (POST)
    - Params:
        - plantId:      int
        - activityType: int
        - time:         date
'''
def add_activity():
    pass

'''
Gets Activity of a Plant (GET)
    - Params:
        - plantId: int
    - Return:
        - time series of activity
'''
def get_activity():
    pass

# ==== Plant Type Management Endpoints ====
# Consider if these endpoints are really necessary.
# We can manually manage the data. But that also saying,
# If a new plant type comes in we might want to verify it. Eh. dunno.

'''
Adds a Plant Type (ADMIN)
    - Params:
        - commonName:     string
        - fullName:       string
        - type:           string
    - Process:
        - Create new requirement/s for plant type
        - Create new plant type w/ requirement

Note: do we need one of these? We could add them manually (thinking admin and auth bleh)
'''

'''
Deletes a Plant Type (ADMIN)
    - Params:
        - plantId: int
'''

@app.route("/test_plant", methods = ["GET"])
@APICall
def test_plant(session):
    return {
        "plant_name": "Rose",
        "scientific_name": "Scientific"
    }, 200

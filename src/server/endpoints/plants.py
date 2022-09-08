from flask import Blueprint, request
from data import Plant, User, PlantType, PlantCareProfile, PlantCareProfileDefault, Activity, ActivityType, Tag, PlantTag
from sqlalchemy.sql.expression import func
from utils.api import APICall
from flask import jsonify

import json


app = Blueprint('plant_endpoints', __name__)

# ===== Personal Plant Management Endpoints ====

# @APICall
# def add_profile(sesh, default: PlantCareProfileDefault, plant: Plant):
#     try:
#         profile = PlantCareProfile(
#             plantId=plant.id, soilType=default.soilType, plantLocation=default.plantLocation,
#             daysBetweenWatering=default.daysBetweenWatering, daysBetweenFertilizer=default.daysBetweenFertilizer,
#             daysBetweenRepotting=default.daysBetweenRepotting)

#         print(profile.serialize())

#         print('add')
#         sesh.add(profile)
#         # session.flush()
#         print('commit')
#         sesh.commit()

#         return "Done", 200
#     except Exception as e:
#         return f"Error: {e}", 500

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

        # # foreign key check
        # print(userId)
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
        plant: Plant = Plant(plantName=personalName, plantDesc=description, plantTypeId=plantTypeId, userId=userId)

        default: PlantCareProfileDefault = session.query(PlantCareProfileDefault).filter(PlantCareProfileDefault.plantTypeId == plantTypeId).first()
        if default is None:
            raise Exception("The default plant care profile could not be found for this plant type")

        session.add(plant)
        session.flush()
        session.refresh(plant)

        profile = PlantCareProfile(
            plantId=plant.id, soilType=default.soilType, plantLocation=default.plantLocation,
            daysBetweenWatering=default.daysBetweenWatering, daysBetweenFertilizer=default.daysBetweenFertilizer,
            daysBetweenRepotting=default.daysBetweenRepotting)

        session.add(profile)
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

# ==== Plant Tags Endpoints ====
@app.route("/plant/<plantId>/tag", methods = ['POST'])
@APICall
def add_plant_tag(session, plantId):
    try:
        label: str = request.form['label']

        # verify information
        if (not label):
            raise KeyError

        # check if plant already exists
        plant = session.query(Plant).filter(Plant.id == plantId).first()
        if not plant:
            return "This plant was not found", 400

    except KeyError as e:
        return "To add a tag, you must provide: label: str", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # add to database
    try:
        tag = Tag(label=label)
        session.add(tag)
        session.flush()
        session.refresh(tag)

        plantTag = PlantTag(typeId=plant.plantTypeId, tagId=tag.id)
        session.add(plantTag)
        session.commit()

    except Exception as e:
        print("An unknown error occurred:", e)

    return 'The tag was added successfully', 200

'''
Only removes the tag associated with the plant. The tag remains in the DB.
'''
@app.route("/plant/<plantId>/tag", methods = ['DELETE'])
@APICall
def remove_plant_tag(session, plantId):
    try:
        tagId: str = request.form['tagId']

        # verify information
        if (not tagId):
            raise KeyError

        # check if plant already exists
        plant = session.query(Plant).filter(Plant.id == plantId).first()
        if not plant:
            return "This plant was not found", 400
    except KeyError as e:
        return "To remove a tag, you must provide: tagId: int", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # attempt a deletion
    try:
        tag = session.query(PlantTag).filter(PlantTag.tagId == tagId).first()
        
        if not tag:
            return "This tag does not exist", 400

        session.delete(tag)
        session.commit()
    except Exception as e:
        return "Error deleting tag:", e, 500

    return "Tag was successfully deleted", 200



# ==== Miscellaneous Plant Endpoints ====



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
        "scientific_name": "Scientific",
        "tags": [],
        "imageUrls": []
    }, 200

from flask import Blueprint, request
from data import Plant, User, PlantType, PlantCareProfile, PlantCareProfileDefault, Activity, ActivityType, Tag, PlantTag, Photo
from sqlalchemy.sql.expression import func
from sqlalchemy.orm import close_all_sessions
from utils.api import APICall, api_auth
from flask import jsonify

import json


app = Blueprint('plant_endpoints', __name__)

# ===== Personal Plant Management Endpoints ====

@app.route("/planttypes", methods= ["GET"])
@APICall
@api_auth
def get_plant_types(session):
    plantTypes = session.query(PlantType).all()
    allTypes = [plantType.serialize() for plantType in plantTypes]
    return jsonify(plantTypes=allTypes)

'''
Update a personal plant with new nickname and/or description
'''
@app.route("/plant/update", methods = ["PATCH"])
@APICall
@api_auth
def update_plant(session):
    try:
        plantId: int     = request.form['plantId']
        nickname: str    = request.form['nickname']
        description: str = request.form['description']

        if (not nickname or
            not description or
            not plantId):
            raise KeyError

        plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()
        if (not plant):
            return f"The plant with id [{plantId}] could not be found", 400

    except KeyError as e:
        return "To update a plant, you must provide - plantId: int, nickname: str, description: str", 400
    except Exception as e:
        return "An unknown exception occurred", 500

    # update the database
    try:
        plant.plantName = nickname
        plant.plantDesc = description
        session.commit()
    except Exception as e:
        return f"A database error occurred: {e}", 500

    return plant.serialize(), 200

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
@api_auth
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
        plantType: PlantType = session.query(PlantType).filter(PlantType.id == plantTypeId).first()
        if (userCount == 0 or not plantType):
            return "Invalid user or plant type information", 400

    except KeyError as e:
        return "To add a plant, you must provide: personalName: str, description: str, userId: str, photoUrl: str, plantTypeId: str, plantTags: [str]", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400

    # add to DB
    try:
        default: PlantCareProfileDefault = session.query(PlantCareProfileDefault).filter(PlantCareProfileDefault.plantTypeId == plantTypeId).first()
        if default is None:
            raise Exception("The default plant care profile could not be found for this plant type")

        # session.add(plant)
        # session.flush()
        # session.refresh(plant)

        profile = PlantCareProfile(
            soilType=default.soilType, plantLocation=default.plantLocation,
            daysBetweenWatering=default.daysBetweenWatering, daysBetweenFertilizer=default.daysBetweenFertilizer,
            daysBetweenRepotting=default.daysBetweenRepotting)

        session.add(profile)
        session.flush()
        session.refresh(profile)

        plant: Plant = Plant(plantName=personalName, plantDesc=description, plantTypeId=plantTypeId, userId=int(userId), careProfileId=profile.id)
        plant.plantType = plantType

        session.add(plant)
        session.commit()

    except Exception as e:
        return "A database error occurred:", e, 400

    return plant.serialize(), 200

'''
Gets a PERSONAL Plant (GET)
    - Params:
        - plantId: int and/or username: string
    - Returns:
        - all plant information
'''
@app.route("/plant/<id>", methods = ["GET"])
@APICall
@api_auth
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
@api_auth
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
@api_auth
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
@api_auth
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


# ==== Photo Endpoints ====

'''
Add a photo URI to a plant.

'''
@app.route("/plant/photos/add", methods = ['POST'])
@APICall
@api_auth
def add_plant_photo(session):
    try:
        plantId: int = request.form['plantId']
        uri: str     = request.form['uri']

        # verify information
        if (not plantId or 
            not uri):
            raise KeyError
        

        # check plant exists
        plant = session.query(Plant).filter(Plant.id == plantId).first()
        if (not plant):
            return 'Could not find plant with id = %s' %plantId, 400

        newPhoto = Photo(uri=uri, plantId=plantId)
        session.add(newPhoto)
        session.commit()

    except KeyError as e:
        return 'To add a photo, please provide a plantId: int and uri: string', 400
        
    except Exception as e:
        return 'Error adding photo:', e, 400

    return 'Added photo successfully', 200

    
'''
Remove a photo URI from a plant.

'''
@app.route("/plant/photos/remove", methods = ['DELETE'])
@APICall
@api_auth
def delete_plant_photo(session):
    try:
        uri: str = request.form['uri']


        # verify information
        if (not uri):
            raise KeyError

        photos = session.query(Photo).filter(Photo.uri == uri).all()
        if (not photos):
            return 'Could not find photos with uri = %s' %uri, 400

        for p in photos:
            session.delete(p)
        session.commit()        

    except KeyError as e:
        return 'To remove a photo, please provide a uri: string.', 400
        
    except Exception as e:
        return 'Unknown error removing photo', e, 400

    return 'Removed photo successfully', 200

'''
Return a collection of photos for a given plant id.
'''
@app.route("/plant/photos", methods = ["GET"])
@APICall
@api_auth
def get_plant_photos(session):
    try:
        plantId: int = request.form['plantId']

        if (not plantId):
            return 'Please provide a plantId: int.', 400
        
        plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()

        if not plant:
            return "The requested plant was not found", 400
    except Exception as e:
        return "To return plant photos, please provide plantId: int", 400

    try:
        photos: Photo = session.query(Photo).filter(Photo.plantId == plantId).all()
        allPhotos = [p.serialize_compact() for p in photos]
        return jsonify(photoList=allPhotos), 200
    
    except Exception as e:
        return "Error getting photo list", 400

'''
Return a map of URL:timestamp, time in ISO-8601
'''
@app.route("/plant/photosmap", methods = ["GET"])
@APICall
@api_auth
def get_plant_photo_map(session):
    try:
        plantId: int = request.form['plantId']

        if (not plantId):
            return 'Please provide a plantId: int.', 400
        
        plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()

        if not plant:
            return "The requested plant was not found", 400
    except Exception as e:
        return "To return plant photos, please provide plantId: int", 400

    try:
        photos: Photo = session.query(Photo).filter(Photo.plantId == plantId).all()

        allPhotos = {p.photoTime.isoformat():p.uri for p in photos}
            # iso and uri are not guaranteed unique but i feel like that's enough of an edge case to ignore :)

        return jsonify(photoMap=allPhotos), 200
    
    except Exception as e:
        return "Error getting photo list", 400
            


# ==== Miscellaneous Plant Endpoints ====

'''
Misc endpoint to make sure the API is running and okay
'''
@app.route("/status", methods=["GET", "POST"])
@APICall
def status(session):
    return "API is running and OK", 200

@app.route("/killoffconnections", methods=["POST"])
@APICall
@api_auth
def killoff(session):
    try:
        close_all_sessions()
        return "All sessions closed", 200
    except Exception as e:
        return f"Something went wrong: {e}", 500


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

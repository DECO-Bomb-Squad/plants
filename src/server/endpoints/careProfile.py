from flask import Blueprint, request
from utils.api import APICall
from flask import jsonify

from data import PlantCareProfile, Plant

app = Blueprint('care_profile_endpoints', __name__)

'''
Get a plant care profile from id
'''
@app.route('/careprofile/<id>', methods=['GET'])
@APICall
def get_plant_care_profile(session, id):
    try:
        careProfile: PlantCareProfile = session.query(PlantCareProfile).filter(PlantCareProfile.id == id).first()
        if (not careProfile):
            return f"This plant care profile does not exist, id: [{id}]", 400

        return careProfile.serialize(), 200
    except Exception as e:
        return f"An error getting the care profile occurred: {e}", 500

'''
Assign a care profile to a plant
'''
@app.route('/careprofile/assign', methods=['POST'])
@APICall
def assign_care_profile(session):
    try:
        careProfileId: int = request.form['careProfileId']
        plantId: int       = request.form['plantId']

        if (not careProfileId or
            not plantId):
            raise KeyError

        newCareProfile: PlantCareProfile = session.query(PlantCareProfile).filter(PlantCareProfile.id == careProfileId).first()
        plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()

        if (not newCareProfile or not plant):
            return "Either the given plant care profile or plant was not found", 400
        
    except KeyError:
        return "Assigns a care profile requires - careProfileId: int, plantId: int", 400
    except Exception as e:
        return f"An unknown exception occured: {e}", 500

    try:
        plant.careProfileId = careProfileId
        plant.careProfile = newCareProfile
        session.commit()
    except Exception as e:
        return "An unknown exception occured: {e}", 500

    return "Plant care profile assigning was completed successfully", 200

'''
Create an ORPHANED care profile
'''
@app.route("/careprofile/add", methods = ["POST"])
@APICall
def create_care_profile(session):
    try:
        soilType: str = request.form['soilType']
        plantLocation: str = request.form['plantLocation']

        daysBetweenRepotting: int  = request.form['daysBetweenRepotting']
        daysBetweenWatering: int   = request.form['daysBetweenWatering']
        daysBetweenFertilizer: int = request.form['daysBetweenFertilizer']

        # check that all keys are not empty
        if (not soilType or
            not plantLocation or
            not daysBetweenRepotting or
            not daysBetweenWatering or
            not daysBetweenFertilizer):
            raise KeyError

    except KeyError as e:
        return '''To update a care profile, you must provide - careProfileId: int, soilType: str,
         plantLocation: str, daysBetweenRepotting: int, daysBetweenWatering: int, daysBetweenFertilizer: int''', 400
    except Exception as e:
        return "An unknown exception occurred", 500

    # update the database
    try:
        careProfile = PlantCareProfile(soilType, plantLocation, daysBetweenWatering, daysBetweenFertilizer, daysBetweenRepotting)
        session.add(careProfile)
        session.commit()
    except Exception as e:
        return f"A database error occurred: {e}", 500

    return careProfile.serialize(), 200

'''
Update a personal plant careprofile
'''
@app.route("/careprofile/update", methods = ["PATCH"])
@APICall
def update_care_profile(session):
    try:
        careProfileId: int = request.form['careProfileId']

        soilType: str = request.form['soilType']
        plantLocation: str = request.form['plantLocation']

        daysBetweenRepotting: int  = request.form['daysBetweenRepotting']
        daysBetweenWatering: int   = request.form['daysBetweenWatering']
        daysBetweenFertilizer: int = request.form['daysBetweenFertilizer']

        # check that all keys are not empty
        if (not careProfileId or
            not soilType or
            not plantLocation or
            not daysBetweenRepotting or
            not daysBetweenWatering or
            not daysBetweenFertilizer):
            raise KeyError

        careProfile: PlantCareProfile = session.query(PlantCareProfile).filter(PlantCareProfile.id == careProfileId).first()
        if (not careProfile):
            return f"The care profile with id [{careProfileId}] could not be found", 400

    except KeyError as e:
        return '''To update a care profile, you must provide - careProfileId: int, soilType: str,
         plantLocation: str, daysBetweenRepotting: int, daysBetweenWatering: int, daysBetweenFertilizer: int''', 400
    except Exception as e:
        return "An unknown exception occurred", 500

    # update the database
    try:
        careProfile.soilType = soilType
        careProfile.plantLocation = plantLocation
        careProfile.daysBetweenFertilizer = daysBetweenFertilizer
        careProfile.daysBetweenRepotting = daysBetweenRepotting
        careProfile.daysBetweenWatering = daysBetweenWatering

        session.commit()
    except Exception as e:
        return f"A database error occurred: {e}", 500

    return careProfile.serialize(), 200
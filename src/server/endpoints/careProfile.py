from flask import Blueprint, request
from utils.api import APICall
from flask import jsonify

from data import PlantCareProfile

app = Blueprint('care_profile_endpoints', __name__)

'''
Update a personal plant with new nickname and/or description
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
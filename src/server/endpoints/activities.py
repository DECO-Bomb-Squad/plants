from flask import Blueprint, request
from data import Plant, ActivityType, Activity
from utils.api import APICall, api_auth
from flask import jsonify

import json


app = Blueprint('activities', __name__)

'''
Adds an Activity to a Plant (POST)
    - Params:
        - plantId:      int
        - activityType: int
        - time:         date
'''
@app.route('/activity', methods = ['POST'])
@APICall
@api_auth
def add_activity(session):
    try:
        plantId = request.form['plantId']
        activityTypeId = request.form['activityTypeId']
        time = request.form['time']

        # verify all information is present
        if (not plantId or
            not activityTypeId or
            not time):
            raise KeyError

        # dealing with enums
        activityTypeId = str(int(activityTypeId) + 1)

        plantCount: int = session.query(Plant).filter(Plant.id == plantId).count()
        activityType: ActivityType = session.query(ActivityType).filter(ActivityType.id == activityTypeId).first()
        if (plantCount == 0):
            return "This plant was not found", 400
        if (not activityType):
            return "This activity type was not found", 400

    except KeyError as e:
        return "This endpoint requires plantId: int, activityTypeId: int, time: date", 400
    except Exception as e:
        return f"Something went wrong: {e}", 400

    # add to DB
    try:
        activ: Activity = Activity(time=time, activityTypeId=activityTypeId, plantId=plantId)
        session.add(activ)
        session.commit()
    except Exception as e:
        return f"There was a database error: {e}", 500

    return "The activity was added successfully", 200
'''
Gets Activity of a Plant (GET)
    - Params:
        - plantId: int
    - Return:
        - time series of activity
'''
@app.route('/activity/<plantId>', methods = ['GET', 'POST'])
@APICall
@api_auth
def get_activity(session, plantId):
    # verify the ids
    plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()
    activity: Activity = session.query(Activity).filter(Activity.plantId == plantId).all()

    if not plant:
        return "The requested plant was not found", 400
    
    if not activity:
        return "There exist no activities associated with this plant", 400

    # return information about the activities
    allActivities = [a.serialize() for a in activity]
    return jsonify(activites=allActivities), 200
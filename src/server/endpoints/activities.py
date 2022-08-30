from flask import Blueprint, request
from data import Plant, User, PlantType, ActivityType, Activity
from utils.api import APICall

import json


app = Blueprint('activities', __name__)

@app.route("/activity", methods = ["POST"])
@APICall
def add_activity(session):
    try:
        plantId         = request.form['plantId']
        activityTypeID  = request.form['activityTypeId']
        time            = request.form['time']

        # verify all information is present
        if (not plantId or
            not activityTypeID or
            not time):
            raise KeyError

        # foreign key check
        typeCount: int = session.query(ActivityType).filter(ActivityType.id == activityTypeID).count()
        if typeCount == 0:
            return "Invalid activityTypeId. The activityType was not found.", 400

    except KeyError as e:
        return "This endpoint accepts plantId: int, activityTypeId: int, time: datetime", 400
    except Exception as e:
        return "An unknown exception occurred", 400

    # commit to DB
    try:
        activity = Activity(time=time, activityTypeId=activityTypeID, plantId=plantId)
        session.add(activity)
        session.commit()
    except Exception as e:
        return "A database error occurred:", e, 400

    return "The activity was added to the plant successfully", 200

@app.route("/activity/<plantUsername>", methods = ["GET", "POST"])
@APICall
def get_activities():
    pass
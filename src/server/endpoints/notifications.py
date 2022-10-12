from typing import List
from flask import Blueprint, request
from data import User
from data.plants.plant import Plant
from utils.notification_utils import send_notif_to_user
from utils.api import APICall, api_auth

app = Blueprint("notifications", __name__)

@app.route('/send_watering_notifications', methods=['POST'])
@APICall
@api_auth
def send_watering_notifications(session):
    users: List[User] = session.query(User).all()
    notif_count: int = 0
    for user in users:
        need_water: List[Plant] = user.get_plants_needing_water(session)
        message: str
        if len(need_water) == 0:
            continue  # Skip to next user, none of this user's plants need watering
        elif len(need_water) == 1:
            message = f"Your plant {need_water[0].plantName} needs watering!"
        else:
            # More than one plant needs water - make a list of their nicknames
            nicknames: str = ', '.join([p.plantName for p in need_water])
            message = f"{nicknames} need to be watered!"
        send_notif_to_user(user, "Time to water your plants!", message)
        notif_count += 1
    
    return f"Sent notifications to {notif_count} users", 200

@app.route('/send_plant_notification', methods=['POST'])
@APICall
@api_auth
def send_plant_notification(session):
    try:
        plantId:       int = request.form['plantId']
        title:         str = request.form['title']
        message:       str = request.form['message']

        # verify all information is present
        if (not plantId or
            not title or
            not message):
            raise KeyError

        plant: Plant = session.query(Plant).filter(Plant.id == plantId).first()
        if plant is None:
            return "Invalid plant id", 400
        user: User = session.query(User).filter(User.id == plant.userId).first()
        if user is None:
            return "Invalid user information based on plant id", 400

    except KeyError as e:
        return "To send notification must provide plantId: int, title: str, message: str", 400
    except Exception as e:
        return "An unknown error occurred:", e, 400
    send_notif_to_user(user, title, message)
    
    return f"Sent notification to {user.username} about plantId: {plant.id}", 200       
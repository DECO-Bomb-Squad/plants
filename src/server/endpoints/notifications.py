from typing import List
from flask import Blueprint, request
from data import User
from data.plants.plant import Plant
from utils.notification_utils import send_notif_to_user
from utils.api import APICall, api_auth
from firebase_admin import messaging

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
from typing import List
from flask import Blueprint, request
from data import User
from utils.api import APICall, api_auth
from firebase_admin import messaging

app = Blueprint("notifications", __name__)

@app.route('/notif', methods=['POST'])
@APICall
@api_auth
def notif(session):
    user: User = session.query(User).filter(User.id == 666).first()
    tokens: List[str] = user.get_tokens()
    print(tokens)
    message = messaging.MulticastMessage(
        tokens=tokens, 
        notification=messaging.Notification(title="Test", body="Test body"),
        android=messaging.AndroidConfig(priority="high")
    )
    messaging.send_multicast(message)
    return "done", 200
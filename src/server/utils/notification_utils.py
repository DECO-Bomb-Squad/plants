from typing import List
from data import User
from firebase_admin import messaging

def send_notif_to_user(user: User, title: str, body: str):
    tokens: List[str] = user.get_tokens()
    message = messaging.MulticastMessage(
        tokens=tokens, 
        notification=messaging.Notification(title=title, body=body),
        android=messaging.AndroidConfig(priority="high")
    )
    messaging.send_multicast(message)

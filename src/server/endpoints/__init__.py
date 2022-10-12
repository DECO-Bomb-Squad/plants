from typing import List
from flask import Blueprint

from . import users
from . import plants
from . import activities
from . import forum
from . import careProfile
from . import notifications

def get_blueprints() -> List[Blueprint]:
    return [
        users.app,
        plants.app,
        careProfile.app,
        activities.app,
        notifications.app,
        forum.app
    ]

    
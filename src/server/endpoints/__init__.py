from typing import List
from flask import Blueprint

from . import users
from . import plants
from . import azure
from . import activities
from . import forum

def get_blueprints() -> List[Blueprint]:
    return [
        users.app,
        plants.app,
        azure.app,
        activities.app,
        forum.app
    ]

    
from enum import Enum

class Privacy(Enum):
    """ Used for determining the privacy level of a plant """
    private   = 0
    followers = 1
    all       = 2
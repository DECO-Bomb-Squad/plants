from data.constants import TBL_ACTIVITY_TYPES
from data.plants.privacy import Privacy
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship

import data.DB as DB

"""
System Activity Type for SQLALchemy
"""
class ActivityType(DB.BASE):
    __tablename__ = TBL_ACTIVITY_TYPES
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column('name', String(255), nullable=False)
    activityDesc = Column('description', String(255), nullable=False)

    # relationships
    activities = relationship("Activity", back_populates='activityType')

    def __init__(self, name, activityDesc):
        self.name = name
        self.activityDesc = activityDesc

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "desc": self.activityDesc
        }

    # will need to add more methods here for getting info and setting info of the user
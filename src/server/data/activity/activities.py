from data.constants import TBL_ACTIVITIES, TBL_ACTIVITY_TYPES, TBL_PLANTS
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

import data.DB as DB

"""
Personal Activity Model for SQLALchemy
"""
class Activity(DB.BASE):
    __tablename__ = TBL_ACTIVITIES
    id = Column(Integer, primary_key=True, autoincrement=True)
    time = Column("time", DateTime(timezone=True), server_default=func.now())

    activityTypeId = Column("activityTypeId", String, ForeignKey(f"{TBL_ACTIVITY_TYPES}.id", name=f"fk_activity_type_id_{__tablename__}"), nullable=False)
    activityType = relationship("ActivityType", back_populates='activity_types')

    plantId = Column("plantId", Integer, ForeignKey(f"{TBL_PLANTS}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    plant = relationship("Plant", back_populates='plants')

    def __init__(self, time, activityTypeId, plantId):
        self.activityTypeId = activityTypeId
        self.plantId = plantId
        self.time = time

    # will need to add more methods here for getting info and setting info of the user
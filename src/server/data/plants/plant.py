from data.constants import TBL_PLANTS, TBL_USERS, TBL_PLANT_TYPES
from data.plants.plantCareProfile import PlantCareProfile
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from flask import jsonify
import json

import data.DB as DB

"""
Personal Plant Model for SQLALchemy
"""
class Plant(DB.BASE):
    __tablename__ = TBL_PLANTS
    id = Column(Integer, primary_key=True, autoincrement=True)
    plantName = Column('plantName', String(255), nullable=False)
    plantDesc = Column('plantDesc', String(255), nullable=False)

    plantTypeId = Column("plantTypeId", Integer, ForeignKey(f"{TBL_PLANT_TYPES}.id", name=f"fk_plant_type_id_{__tablename__}"), nullable=False)
    plantType = relationship("PlantType", uselist=False, backref="plant_types")

    userId = Column(Integer, ForeignKey(f"{TBL_USERS}.id", name=f"fk_user_id_{__tablename__}"), nullable=False)
    user = relationship("User", back_populates='userPlants')

    # individual relationships
    activities = relationship("Activity", back_populates='plant')
    careProfile = relationship("PlantCareProfile", uselist=False, backref="plant_care_profile")


    def __init__(self, plantName, plantDesc, plantTypeId, userId):
        self.plantName = plantName
        self.plantDesc = plantDesc
        self.plantTypeId = plantTypeId
        self.userId = userId

    # def get_serialized_activities(self):
    #     allActivities = [activity.serialize() for activity in self.activities]
    #     return jsonify(plantActivities=allActivities)

    # def get_serialized_status(self):
    #     allStatus = [status.serialize() for status in self.status]
    #     return jsonify(status=allStatus)

    def serialize(self):
        return {
            "id":   self.id,
            "name": self.name,
            "scientific_name": "tbd",
            "description": self.description,
            "plantTypeId": self.plantTypeId,
            # "user":        self.user.plant_serialize(), # NEEDS TESTING { userId: number, username: string}
            # "activities":  self.get_serialized_activities(),
            "careProfile": "tbd", # { status1: value, status2: value }    i.e. location, soil_type
            "tags":        "[tbd]"
        }

    # will need to add more methods here for getting info and setting info of the user
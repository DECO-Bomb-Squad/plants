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
    # tags = relationship("PlantTag", back_populates="plant") # access through plantType

    careProfile = relationship("PlantCareProfile", uselist=False, backref="plant_care_profile")

    photos = relationship("Photo", back_populates="plant")

    def get_serialized_photos(self):
        allPhotos = [photo.serialize() for photo in self.photos]
        return allPhotos

    def __init__(self, plantName, plantDesc, plantTypeId, userId):
        self.plantName = plantName
        self.plantDesc = plantDesc
        self.plantTypeId = plantTypeId
        self.userId = userId

    def get_serialized_activities(self):
        allActivities = [activity.serialize() for activity in self.activities]
        return allActivities

    def get_serialized_tags(self):
        allTags = [tag.serialize() for tag in self.tags]
        return allTags

    def serialize(self):
        return {
            "id":              self.id,
            "name":            self.plantName,
            "scientific_name": self.plantType.fullName,
            "description":     self.plantDesc,
            "plantTypeId":     self.plantTypeId,
            "user":            self.user.snip_serialize(),
            "activities":      self.get_serialized_activities(),
            "careProfile":     self.careProfile.serialize(),
            "tags":            self.plantType.get_serialized_tags(),
            "photos":          self.get_serialized_photos() 
        }

    # will need to add more methods here for getting info and setting info of the user
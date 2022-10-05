from data.constants import TBL_PLANTS, TBL_USERS, TBL_PLANT_TYPES, TBL_PLANT_CARE_PROFILE
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
    plantType = relationship("PlantType", back_populates="plantTypes")

    userId = Column(Integer, ForeignKey(f"{TBL_USERS}.id", name=f"fk_user_id_{__tablename__}"), nullable=False)
    user = relationship("User", back_populates='userPlants')

    careProfileId = Column("careProfileId", Integer, ForeignKey(f"{TBL_PLANT_CARE_PROFILE}.id", name=f"fk_plant_care_profile_id_{__tablename__}"), nullable=False)
    careProfile = relationship("PlantCareProfile", uselist=False, backref="plant_care_profile")

    # individual relationships
    activities = relationship("Activity", back_populates='plant')
    # tags = relationship("PlantTag", back_populates="plant") # access through plantType

    photos = relationship("Photo", back_populates="plant")

    posts = relationship("PostPlant", back_populates='plant')

    def get_serialized_photos(self):
        allPhotos = {p.photoTime.isoformat():p.uri for p in self.photos}
        return allPhotos

    def __init__(self, plantName, plantDesc, plantTypeId, userId, careProfileId):
        self.plantName = plantName
        self.plantDesc = plantDesc
        self.plantTypeId = plantTypeId
        self.userId = userId
        self.careProfileId = careProfileId

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
            "common_name":     self.plantType.commonName,
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
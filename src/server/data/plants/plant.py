from data.constants import TBL_PLANTS, TBL_USERS, TBL_PLANT_TYPES
from data.plants.privacy import Privacy
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
    name = Column('name', String(255), nullable=False)
    description = Column('description', String(255), nullable=False)

    plantTypeId = Column("plantTypeId", Integer, ForeignKey(f"{TBL_PLANT_TYPES}.id", name=f"fk_plant_type_id_{__tablename__}"), nullable=False)
    plantType = relationship("PlantType", back_populates='plant')

    userId = Column(Integer, ForeignKey(f"{TBL_USERS}.id", name=f"fk_user_id_{__tablename__}"), nullable=False)
    user = relationship("User", back_populates='userPlants')

    activities = relationship("Activity", back_populates='plant')


    def __init__(self, name, description, plantTypeId, userId):
        self.name = name
        self.description = description
        self.plantTypeId = plantTypeId
        self.userId = userId

    def serialize(self):
        return {
            "id":   self.id,
            "name": self.name,
            "description": self.description,
            "plantTypeId": self.plantTypeId,
            "userId":      self.userId
        }

    # will need to add more methods here for getting info and setting info of the user
from data.constants import TBL_PLANT_CARE_PROFILE, TBL_PLANTS
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from flask import jsonify

import data.DB as DB

"""
Plant Care Profile for SQLALchemy
"""
class PlantCareProfile(DB.BASE):
    __tablename__ = TBL_PLANT_CARE_PROFILE
    id = Column(Integer, primary_key=True, autoincrement=True)

    plantId = Column("plantId", Integer, ForeignKey(f"{TBL_PLANTS}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    # plant = relationship("Plant", back_populates="status") NOT 1-1

    soilType = Column('soilType', String(100), nullable=False)
    location = Column('location', String(100), nullable=False)
    daysBetweenWatering = Column('daysBetweenWatering', Integer, nullable=False)

    daysBetweenRepotting = Column('daysBetweenRepotting', Integer, nullable=True)
    daysBetweenFertilizer = Column('daysBetweenFertilizer', Integer, nullable=True)
    
    def __init__(self, soilType, location, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer):
        self.soilType = soilType
        self.location = location
        self.daysBetweenWatering = daysBetweenWatering
        self.daysBetweenRepotting = daysBetweenRepotting
        self.daysBetweenFertilizer = daysBetweenFertilizer

    def serialize(self):
        return {
            "id": self.id,
            "plantId": self.plantId,
            "soilType": self.soilType,
            "location": self.location,
            "daysBetweenWatering": self.daysBetweenWatering,
            "daysBetweenRepotting": self.daysBetweenRepotting if self.daysBetweenRepotting else -1,
            "daysBetweenFertilizer": self.daysBetweenFertilizer if self.daysBetweenFertilizer else -1
        }
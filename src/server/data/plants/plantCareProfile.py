from data.constants import TBL_PLANT_CARE_PROFILE, TBL_PLANT_CARE_PROFILE_DEFAULT, TBL_PLANTS, TBL_PLANT_TYPES
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from flask import jsonify

import data.DB as DB

"""
Plant Care Profile for SQLALchemy
"""
class PlantCareProfile(DB.BASE):
    __tablename__ = TBL_PLANT_CARE_PROFILE
    id = Column("id", Integer, primary_key=True, autoincrement=True)

    # plantId = Column("plantId", Integer, ForeignKey(f"{TBL_PLANTS}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    # plant = relationship("Plant", back_populates="careProfile") # NOT 1-1    

    soilType = Column('soilType', String(100), nullable=False)
    plantLocation = Column('plantLocation', String(100), nullable=False)
    daysBetweenWatering = Column('daysBetweenWatering', Integer, nullable=False)

    daysBetweenRepotting = Column('daysBetweenRepotting', Integer, nullable=True)
    daysBetweenFertilizer = Column('daysBetweenFertilizer', Integer, nullable=True)
    
    def __init__(self, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer):
        self.soilType = soilType
        self.plantLocation = plantLocation
        self.daysBetweenWatering = daysBetweenWatering
        self.daysBetweenRepotting = daysBetweenRepotting
        self.daysBetweenFertilizer = daysBetweenFertilizer

    def serialize(self):
        return {
            "id": self.id,
            "soilType": self.soilType,
            "plantLocation": self.plantLocation,
            "daysBetweenWatering": self.daysBetweenWatering,
            "daysBetweenRepotting": self.daysBetweenRepotting if self.daysBetweenRepotting else -1,
            "daysBetweenFertilizer": self.daysBetweenFertilizer if self.daysBetweenFertilizer else -1
        }

"""
Plant Care Profile Default for SQLALchemy
"""
class PlantCareProfileDefault(DB.BASE):
    __tablename__ = TBL_PLANT_CARE_PROFILE_DEFAULT
    id = Column(Integer, primary_key=True, autoincrement=True)

    plantTypeId = Column("plantTypeId", Integer, ForeignKey(f"{TBL_PLANT_TYPES}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    plant = relationship("PlantType", back_populates="defaultCareProfile", overlaps="plant_care_profile_default")

    soilType = Column('soilType', String(100), nullable=False)
    plantLocation = Column('plantLocation', String(100), nullable=False)
    daysBetweenWatering = Column('daysBetweenWatering', Integer, nullable=False)

    daysBetweenRepotting = Column('daysBetweenRepotting', Integer, nullable=True)
    daysBetweenFertilizer = Column('daysBetweenFertilizer', Integer, nullable=True)
    
    def __init__(self, soilType, plantLocation, daysBetweenWatering, daysBetweenRepotting, daysBetweenFertilizer):
        self.soilType = soilType
        self.plantLocation = plantLocation
        self.daysBetweenWatering = daysBetweenWatering
        self.daysBetweenRepotting = daysBetweenRepotting
        self.daysBetweenFertilizer = daysBetweenFertilizer

    def serialize(self):
        return {
            "id": self.id,
            "plantTypeId": self.plantTypeId,
            "soilType": self.soilType,
            "plantLocation": self.plantLocation,
            "daysBetweenWatering": self.daysBetweenWatering,
            "daysBetweenRepotting": self.daysBetweenRepotting if self.daysBetweenRepotting else -1,
            "daysBetweenFertilizer": self.daysBetweenFertilizer if self.daysBetweenFertilizer else -1
        }
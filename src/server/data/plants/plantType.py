from data.constants import TBL_PLANT_TYPES
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

import data.DB as DB

"""
System Plant Type for SQLALchemy
"""
class PlantType(DB.BASE):
    __tablename__ = TBL_PLANT_TYPES
    id = Column(Integer, primary_key=True, autoincrement=True)
    type = Column('type', String(255), nullable=False)
    commonName = Column('commonName', String(255), nullable=False)
    fullName = Column('fullName', String(255), nullable=False)

    # relationships
    plants = relationship("Plant", back_populates='plantType')
    defaultCareProfile = relationship("PlantCareProfileDefault", uselist=False, backref="plant_care_profile_default")
    
    tags = relationship("PlantTag", back_populates="plantType")

    def get_serialized_tags(self):
        allTags = [tag.serialize() for tag in self.tags]
        return allTags

    def serialize(self):
        return {
            "id": self.id,
            "type": self.type,
            "commonName": self.commonName,
            "fullName": self.fullName
        }

    def __init__(self, type, commonName, fullName):
        self.type = type
        self.commonName = commonName
        self.fullName = fullName

    # will need to add more methods here for getting info and setting info of the user
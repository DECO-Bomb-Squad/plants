from data.constants import TBL_TAGS
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

import data.DB as DB

"""
System Plant Tag for SQLALchemy
"""
class Tag(DB.BASE):
    __tablename__ = TBL_TAGS
    id = Column(Integer, primary_key=True, autoincrement=True)
    label = Column('label', String(255), nullable=False)

    # one relationship will be needed for post tags as well
    plantTypes = relationship("PlantTag", back_populates="tag")
    # tags = relationship("PlantTag", back_populates="plantType")

    def __init__(self, type):
        self.plantTypeId = type

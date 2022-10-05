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

    plantTypes = relationship("PlantTag", back_populates="tag")
    posts = relationship("PostTag", back_populates="tag")

    def __init__(self, label):
        self.label = label

    def serialize(self):
        return {
            "tagId": self.id,
            "label": self.label
        }

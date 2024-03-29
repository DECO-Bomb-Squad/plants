from data.constants import TBL_PLANT_TAGS, TBL_PLANT_TYPES, TBL_TAGS
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

import data.DB as DB

"""
System Plant Tag for SQLALchemy
"""
class PlantTag(DB.BASE):
    __tablename__ = TBL_PLANT_TAGS
    id = Column(Integer, primary_key=True, autoincrement=True)

    plantTypeId = Column("plantTypeId", Integer, ForeignKey(f"{TBL_PLANT_TYPES}.id", name=f"fk_plant_type_id_{__tablename__}"), nullable=False)
    plantType = relationship("PlantType", uselist=False, back_populates="tags")

    tagId = Column("tagId", Integer, ForeignKey(f"{TBL_TAGS}.id", name=f"fk_tag_id_{__tablename__}"), nullable=False)
    tag = relationship("Tag", uselist=False, back_populates="plantTypes")

    def __init__(self, typeId, tagId):
        self.plantTypeId = typeId
        self.tagId = tagId

    def serialize(self):
        return {
            "plantTagId": self.id,
            "plantTypeId": self.plantTypeId,
            "tagLabel": self.tag.label
        }

from data.constants import TBL_PHOTOS, TBL_PLANTS
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

import data.DB as DB

"""
Plant Photo for SQLALchemy
"""
class Photo(DB.BASE):
    __tablename__ = TBL_PHOTOS
    id = Column(Integer, primary_key=True, autoincrement=True)
    uri = Column("uri", String(255), nullable=False)
    photoTime = Column("photoTime", DateTime(timezone=True), server_default=func.now())

    # link to plant
    plantId = Column("plantId", Integer, ForeignKey(f"{TBL_PLANTS}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    plant = relationship("Plant", back_populates="photos")

    def __init__(self, uri, plantId):
        self.uri = uri
        self.photoTime = func.now()
        self.plantId = plantId

    # standard serialize
    def serialize(self):
        return {
            "photoId": self.id,
            "uri": self.uri,
            "timestamp": self.photoTime.isoformat(),
            "plantId": self.plantId
        }

    # compact serialize
    def serialize_compact(self):
        return {
            "photoId": self.id,
            "uri": self.uri,
            "timestamp": self.photoTime.isoformat()
        }

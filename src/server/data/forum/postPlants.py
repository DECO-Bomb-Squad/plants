from data.constants import TBL_PLANTS, TBL_POST_PLANTS, TBL_POSTS
from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship

import data.DB as DB

"""
Forum Post/Plant Association Model for SQLALchemy
"""
class PostPlant(DB.BASE):
    __tablename__ = TBL_POST_PLANTS
    id = Column(Integer, primary_key=True, autoincrement=True)

    plantId = Column(Integer, ForeignKey(f"{TBL_PLANTS}.id", name=f"fk_plant_id_{__tablename__}"), nullable=False)
    plant = relationship("Plant", uselist=False, back_populates='posts')
    # should useList = true here for multiple plants?

    postId = Column(Integer, ForeignKey(f"{TBL_POSTS}.id", name=f"fk_post_id_{__tablename__}"), nullable=False)
    post = relationship("Post", uselist=False, back_populates="plants")

    def __init__(self, plantId, postId):
        self.plantId = plantId
        self.postId = postId

    def serialize(self):
        return {
            "plantId": self.plantId,
            "postId": self.postId
        }

    # will need to add more methods here for getting info and setting info of the user
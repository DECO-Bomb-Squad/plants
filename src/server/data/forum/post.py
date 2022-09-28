from data.constants import TBL_PLANTS, TBL_USERS, TBL_PLANT_TYPES, TBL_POSTS
from data.plants.plantCareProfile import PlantCareProfile
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from flask import jsonify
import json

import data.DB as DB

"""
Forum Post Model for SQLALchemy
"""
class Post(DB.BASE):
    __tablename__ = TBL_POSTS
    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column('title', String(255), nullable=False)
    content = Column('content', String(255), nullable=False)
    created = Column("created", DateTime(timezone=True), server_default=func.now())
    score = Column('score', Integer, nullable=False)


    userId = Column("userId", Integer, ForeignKey(f"{TBL_USERS}.id", name=f"fk_user_post_id_{__tablename__}"), nullable=False)
    author = relationship("User", back_populates='userPosts')

    comments = relationship("Comment", back_populates='post')

    plants = relationship("PostPlant", back_populates='post')

    tags = relationship("PostTag", back_populates='post')

    def __init__(self, title, content, userId):
        self.title = title
        self.content = content
        self.userId = userId
        self.created = func.now()
        self.score = 0

    def serialize(self):
        return {
            "postId":          self.id,
            "title":           self.title,
            "content":         self.content,
            "created":         self.created,
            "userId":          self.userId,
            "score":           self.score
        }
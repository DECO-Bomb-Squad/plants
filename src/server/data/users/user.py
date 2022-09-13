from flask import jsonify
from data.constants import TBL_USERS
from data.plants import Plant, PlantType
from sqlalchemy import Column, Integer, String, DateTime, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

import data.DB as DB

"""
User Model for SQLALchemy
"""
class User(DB.BASE):
    __tablename__ = TBL_USERS
    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column('username', String(255), nullable=False)
    UniqueConstraint(username, name='UNQIUE-username')
    email = Column('email', String(64), nullable=False)
    bio = Column('bio', String(255), nullable=True)
    startDate = Column('startDate', DateTime(timezone=True), default = func.now())
    reputation = Column('reputation', Integer, nullable=False)

    # relationships
    userPlants = relationship("Plant", back_populates="user")

    def __init__(self, username, email, bio=None, reputation=0, startDate=func.now()) -> None:
        self.username = username
        self.email = email
        self.bio = bio
        self.reputation = reputation
        self.startDate = startDate

    def get_serialized_plants(self):
        allPlants = [plant.serialize() for plant in self.userPlants]
        return jsonify(userPlants=allPlants)

    def snip_serialize(self):
        return {
            "userId":   self.id,
            "username": self.username
        }

    def serialize(self):
        return {
            "userId": self.id,
            "username": self.username,
            "email": self.email,
            "startDate": self.startDate,
            "reputation": self.reputation,
            "bio": self.bio if self.bio else ""
        }
        

    # will need to add more methods here for getting info and setting info of the user
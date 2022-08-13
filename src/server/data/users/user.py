from data.constants import TBL_USERS
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
    startDate = Column('startDate', DateTime(timezone=True), server_default=func.now())

    # relationships
    plants = relationship("Plant", back_populates="plants")

    def __init__(self, username, email, bio=None) -> None:
        self.username = username
        self.email = email
        self.bio = bio

    # will need to add more methods here for getting info and setting info of the user
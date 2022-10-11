from flask import jsonify
from data.constants import TBL_TOKENS, TBL_USERS
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

import data.DB as DB

class Token(DB.BASE):
    __tablename__ = TBL_TOKENS
    id = Column(Integer, primary_key=True, autoincrement=True)
    token = Column(String, nullable=False)

    userId = Column('userId', Integer, ForeignKey(f"{TBL_USERS}.id"), nullable=False)
    user = relationship("User", back_populates='tokens')

    def __init__(self, userId, token):
        self.userId = userId
        self.token = token
        
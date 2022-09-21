from data.constants import TBL_POST_TAGS, TBL_POSTS, TBL_TAGS
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

import data.DB as DB

"""
Forum Post Tag for SQLALchemy
"""
class PostTag(DB.BASE):
    __tablename__ = TBL_POST_TAGS
    id = Column(Integer, primary_key=True, autoincrement=True)

    postId = Column("postId", Integer, ForeignKey(f"{TBL_POSTS}.id", name=f"fk_post_id_{__tablename__}"), nullable=False)
    post = relationship("Post", uselist=False, back_populates="tags")

    tagId = Column("tagId", Integer, ForeignKey(f"{TBL_TAGS}.id", name=f"fk_tag_id_{__tablename__}"), nullable=False)
    tag = relationship("Tag", uselist=False, back_populates="posts")

    def __init__(self, postId, tagId):
        self.postId = postId
        self.tagId = tagId

    def serialize(self):
        return {
            "plantTagId": self.id,
            "plantTypeId": self.plantTypeId,
            "tagLabel": self.tag.label
        }

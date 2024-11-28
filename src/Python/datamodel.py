from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime, timezone, timedelta


class Data(Base):
    __tablename__ = 'Data'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, index=True, unique=True)
    contents = Column(String)
    upload_date = Column(DateTime, default=lambda: datetime.now(timezone.utc) + timedelta(hours=2))
    last_edit_date = Column(DateTime, nullable=True)
    category_id = Column(Integer, ForeignKey('Category.id'))

    category = relationship("Category", back_populates="data_items")


class Category(Base):
    __tablename__ = 'Category'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, index=True)
    description = Column(String, nullable=True)

    data_items = relationship("Data", back_populates="category")

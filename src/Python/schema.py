from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class DataCreate(BaseModel):
    id: Optional[int] = None
    name: str
    contents: str
    upload_date: Optional[datetime] = None
    last_edit_date: Optional[datetime] = None
    category_id: int


class DataResponse(DataCreate):
    class Config:
        from_attributes = True


class DataPatch(BaseModel):
    id: int = None
    name: str = None
    contents: str = None
    upload_date: datetime = None
    last_edit_date: Optional[datetime] = None
    category_id: int = None


class CategoryCreate(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None


class CategoryResponse(CategoryCreate):
    class Config:
        orm_mode = True


class CategoryPatch(BaseModel):
    id: int = None
    name: str = None
    description: Optional[str] = None

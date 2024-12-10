# Реалізація інформаційного та програмного забезпечення

## SQL-скрипт для створення та початкового наповнення бази даних

```sql
  CREATE DATABASE lab5;
USE lab5;

-- Таблица User
CREATE TABLE User (
    id CHAR(36) PRIMARY KEY, -- Хранение UUID
    password TEXT NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL, -- Указана длина для UNIQUE
    email VARCHAR(100) UNIQUE NOT NULL,   -- Указана длина для UNIQUE
    role VARCHAR(50) NOT NULL
);

-- Таблица Attributes
CREATE TABLE Attributes (
    id CHAR(36) PRIMARY KEY,
    description TEXT,
    value TEXT,
    attributeType VARCHAR(50),
    name VARCHAR(100)
);

-- Таблица Permissions
CREATE TABLE Permissions (
    id CHAR(36) PRIMARY KEY,
    description TEXT,
    level INT,
    name VARCHAR(100)
);

-- Таблица UserAttributes
CREATE TABLE UserAttributes (
    UserID CHAR(36),
    AttributeID CHAR(36),
    PRIMARY KEY (UserID, AttributeID),
    FOREIGN KEY (UserID) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (AttributeID) REFERENCES Attributes(id) ON DELETE CASCADE
);

-- Таблица Search
CREATE TABLE Search (
    id CHAR(36) PRIMARY KEY,
    status VARCHAR(50),
    searchType VARCHAR(50),
    target TEXT,
    parameters TEXT
);

-- Таблица User_has_Search
CREATE TABLE User_has_Search (
    User_id CHAR(36),
    Search_id CHAR(36),
    PRIMARY KEY (User_id, Search_id),
    FOREIGN KEY (User_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (Search_id) REFERENCES Search(id) ON DELETE CASCADE
);

-- Таблица DataLink
CREATE TABLE DataLink (
    link VARCHAR(255) PRIMARY KEY
);

-- Таблица Search_has_DataLink
CREATE TABLE Search_has_DataLink (
    Search_id CHAR(36),
    DataLink_link VARCHAR(255),
    PRIMARY KEY (Search_id, DataLink_link),
    FOREIGN KEY (Search_id) REFERENCES Search(id) ON DELETE CASCADE,
    FOREIGN KEY (DataLink_link) REFERENCES DataLink(link) ON DELETE CASCADE
);

-- Таблица DataFolder
CREATE TABLE DataFolder (
    id CHAR(36) PRIMARY KEY,
    description TEXT,
    date DATETIME,
    owner VARCHAR(100),
    name VARCHAR(100)
);

-- Таблица DataFolder_has_DataLink
CREATE TABLE DataFolder_has_DataLink (
    DataFolder_id CHAR(36),
    DataLink_link VARCHAR(255),
    PRIMARY KEY (DataFolder_id, DataLink_link),
    FOREIGN KEY (DataFolder_id) REFERENCES DataFolder(id) ON DELETE CASCADE,
    FOREIGN KEY (DataLink_link) REFERENCES DataLink(link) ON DELETE CASCADE
);

-- Таблица Data
CREATE TABLE Data (
    id CHAR(36) PRIMARY KEY,
    size DOUBLE,
    date DATETIME,
    dataType VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    tags TEXT,
    createdBy CHAR(36),
    FOREIGN KEY (createdBy) REFERENCES User(id) ON DELETE SET NULL
);

-- Таблица DataLink_has_Data
CREATE TABLE DataLink_has_Data (
    Data_id CHAR(36),
    DataLink_link VARCHAR(255),
    PRIMARY KEY (Data_id, DataLink_link),
    FOREIGN KEY (Data_id) REFERENCES Data(id) ON DELETE CASCADE,
    FOREIGN KEY (DataLink_link) REFERENCES DataLink(link) ON DELETE CASCADE
);

-- Таблица AdminActivityReports
CREATE TABLE AdminActivityReports (
    id CHAR(36) PRIMARY KEY,
    adminID CHAR(36),
    activity TEXT,
    date DATETIME,
    FOREIGN KEY (adminID) REFERENCES User(id) ON DELETE CASCADE
);

-- Таблица AdminRegistration
CREATE TABLE AdminRegistration (
    id CHAR(36) PRIMARY KEY,
    adminID CHAR(36),
    registeredBy CHAR(36),
    date DATETIME,
    FOREIGN KEY (adminID) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (registeredBy) REFERENCES User(id) ON DELETE SET NULL
);

-- Таблица GuestAccess
CREATE TABLE GuestAccess (
    id CHAR(36) PRIMARY KEY,
    dataID CHAR(36),
    accessDate DATETIME,
    guestID CHAR(36),
    FOREIGN KEY (dataID) REFERENCES Data(id) ON DELETE CASCADE
);

-- Таблица RemovedAdminData
CREATE TABLE RemovedAdminData (
    id CHAR(36) PRIMARY KEY,
    adminID CHAR(36),
    removedBy CHAR(36),
    dataID CHAR(36),
    date DATETIME,
    FOREIGN KEY (adminID) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (removedBy) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (dataID) REFERENCES Data(id) ON DELETE CASCADE
);

```

## RESTfull сервіс для управління даними

main.py 

```mysql

from fastapi import FastAPI
from database import engine, Base
from routes import router
Base.metadata.create_all(bind=engine)
app = FastAPI()
app.include_router(router)

```

database.py 

```mysql

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from config import DB_PASSWORD

SQLALCHEMY_DATABASE_URL = f"mysql+pymysql://root:12345678@127.0.0.1:3306/mydb"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

```

models.py

```mysql

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime, timezone, timedelta


class Data(Base):
    __tablename__ = 'Data'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, index=True, unique=True)
    content = Column(String)
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


```

schemas.py

```mysql

from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class DataCreate(BaseModel):
    id: Optional[int] = None
    name: str
    content: str
    upload_date: Optional[datetime] = None
    last_edit_date: Optional[datetime] = None
    category_id: int


class CategoryCreate(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None


class DataResponse(DataCreate):
    class Config:
        orm_mode = True


class CategoryResponse(CategoryCreate):
    class Config:
        orm_mode = True


class CategoryPatch(BaseModel):
    id: int = None
    name: str = None
    description: Optional[str] = None


class DataPatch(BaseModel):
    id: int = None
    name: str = None
    content: str = None
    upload_date: datetime = None
    last_edit_date: Optional[datetime] = None
    category_id: int = None


```

routes.py

```mysql

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from models import Data, Category
from schemas import DataCreate, CategoryCreate, DataResponse, CategoryResponse, CategoryPatch, DataPatch
from database import SessionLocal

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/data/", response_model=List[DataResponse])
async def read_data(db: Session = Depends(get_db)):
    return db.query(Data).all()


@router.get("/data/{data_id}", response_model=DataResponse)
async def read_data_by_id(data_id: int, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(data_id == Data.id).first()
    if db_data is None:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")
    return db_data


@router.post("/data/", response_model=DataResponse)
async def create_data(data: DataCreate, db: Session = Depends(get_db)):
    id_data = db.query(Data).filter(data.id == Data.id).first()
    if id_data:
        raise HTTPException(status_code=400, detail="The data with this ID already exists")

    name_data = db.query(Data).filter(data.name == Data.name).first()
    if name_data:
        raise HTTPException(status_code=400, detail="The data with this name already exists")

    id_category = db.query(Category).filter(data.category_id == Category.id).first()
    if not id_category:
        raise HTTPException(status_code=400, detail="The category with the specified ID was not found")

    db_data = Data(**data.dict())
    db.add(db_data)
    db.commit()
    db.refresh(db_data)

    return db_data


@router.put("/data/{data_id}", response_model=DataResponse)
async def update_data(data_id: int, data: DataCreate, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(data_id == Data.id).first()
    if db_data is None:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    id_data = db.query(Data).filter(data.id == Data.id, data_id != Data.id).first()
    if id_data:
        raise HTTPException(status_code=400, detail="The data with this ID already exists")

    name_data = db.query(Data).filter(data.name == Data.name, data_id != Data.id).first()
    if name_data:
        raise HTTPException(status_code=400, detail="The data with this name already exists")

    if data.category_id:
        id_category = db.query(Category).filter(data.category_id == Category.id).first()
        if not id_category:
            raise HTTPException(status_code=400, detail="The category with the specified ID was not found")

    for key, value in data.dict().items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data


@router.delete("/data/{data_id}", response_model=DataResponse)
async def delete_data(data_id: int, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(data_id == Data.id).first()
    if db_data is None:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    db.delete(db_data)
    db.commit()
    return db_data


@router.patch("/data/{data_id}", response_model=DataResponse)
async def patch_data(data_id: int, data: DataPatch, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(data_id == Data.id).first()
    if db_data is None:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    updated_fields = data.dict(exclude_unset=True)

    if 'id' in updated_fields and updated_fields['id'] != data_id:
        id_data = db.query(Data).filter(Data.id == updated_fields['id']).first()
        if id_data:
            raise HTTPException(status_code=400, detail="The data with this ID already exists")

    if 'name' in updated_fields:
        name_data = db.query(Data).filter(Data.name == updated_fields['name'], data_id != Data.id).first()
        if name_data:
            raise HTTPException(status_code=400, detail="The data with this name already exists")

    if 'category_id' in updated_fields:
        category = db.query(Category).filter(Category.id == updated_fields['category_id']).first()
        if not category:
            raise HTTPException(status_code=400, detail="The category with the specified ID was not found")

    for key, value in updated_fields.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data


@router.get("/category/", response_model=List[CategoryResponse])
async def read_category(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return db.query(Category).offset(skip).limit(limit).all()


@router.get("/category/{category_id}", response_model=CategoryResponse)
async def read_category_by_id(category_id: int, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(category_id == Category.id).first()
    if db_category is None:
        raise HTTPException(status_code=404, detail="The category with the specified ID was not found")
    return db_category


@router.post("/category/", response_model=CategoryResponse)
async def create_category(category: CategoryCreate, db: Session = Depends(get_db)):
    existing_category = db.query(Category).filter(category.id == Category.id).first()
    if existing_category:
        raise HTTPException(status_code=400, detail="The category with this ID already exists")

    db_category = Category(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)

    return db_category


@router.put("/category/{category_id}", response_model=CategoryResponse)
async def update_category(category_id: int, category: CategoryCreate, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(category_id == Category.id).first()
    if db_category is None:
        raise HTTPException(status_code=404, detail="The category with the specified ID was not found")

    id_data = db.query(Data).filter(category.id == Category.id, category_id != Category.id).first()
    if id_data:
        raise HTTPException(status_code=400, detail="The category with this ID already exists")

    for key, value in category.dict().items():
        setattr(db_category, key, value)

    db.commit()
    db.refresh(db_category)
    return db_category


@router.delete("/category/{category_id}", response_model=CategoryResponse)
async def delete_category(category_id: int, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(category_id == Category.id).first()
    if db_category is None:
        raise HTTPException(status_code=404, detail="The category with the specified ID was not found")

    related_data = db.query(Data).filter(category_id == Data.category_id).first()
    if related_data:
        raise HTTPException(status_code=403, detail="Cannot delete category with associated data")

    db.delete(db_category)
    db.commit()
    return db_category


@router.patch("/category/{category_id}", response_model=CategoryResponse)
async def patch_category(category_id: int, category: CategoryPatch, db: Session = Depends(get_db)):
    db_category = db.query(Category).filter(category_id == Category.id).first()
    if db_category is None:
        raise HTTPException(status_code=404, detail="The category with the specified ID was not found")

    updated_data = category.dict(exclude_unset=True)

    if 'id' in updated_data and updated_data['id'] != category_id:
        id_category = db.query(Category).filter(Category.id == updated_data['id']).first()
        if id_category:
            raise HTTPException(status_code=400, detail="The category with this ID already exists")

    for key, value in updated_data.items():
        setattr(db_category, key, value)

    db.commit()
    db.refresh(db_category)
    return db_category

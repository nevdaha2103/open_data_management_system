# Реалізація інформаційного та програмного забезпечення

## SQL-скрипт для створення та початкового наповнення бази даних

```sql
  -- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS mydb ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS mydb ;
USE mydb ;

-- -----------------------------------------------------
-- Table mydb.User
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.User ;

CREATE TABLE IF NOT EXISTS mydb.User (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(32) NOT NULL,
  account_creation_date DATETIME NOT NULL,
  last_login_date DATETIME NULL DEFAULT NULL,
  Role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Role_id`),
  UNIQUE INDEX email_UNIQUE (`email` ASC) VISIBLE,
  INDEX fk_User_Role_idx (`Role_id` ASC) VISIBLE,
  CONSTRAINT fk_User_Role
    FOREIGN KEY (`Role_id`)
    REFERENCES mydb.Role (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Session
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Session ;

CREATE TABLE IF NOT EXISTS mydb.Session (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  login_time DATETIME NOT NULL,
  logout_time DATETIME NOT NULL,
  User_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `User_id`),
  INDEX fk_Session_User1_idx (`User_id` ASC) VISIBLE,
  CONSTRAINT fk_Session_User1
    FOREIGN KEY (`User_id`)
    REFERENCES mydb.User (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Role
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Role ;

CREATE TABLE IF NOT EXISTS mydb.Role (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX name_UNIQUE (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Category
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Category ;

CREATE TABLE IF NOT EXISTS mydb.Category (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Permission
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Permission ;

CREATE TABLE IF NOT EXISTS mydb.Permission (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(255) NULL DEFAULT NULL,
  Role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Role_id`),
  INDEX fk_Permission_Role1_idx (`Role_id` ASC) VISIBLE,
  CONSTRAINT fk_Permission_Role1
    FOREIGN KEY (`Role_id`)
    REFERENCES mydb.Role (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Data
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Data ;

CREATE TABLE IF NOT EXISTS mydb.Data (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  contents VARCHAR(255) NOT NULL,
  upload_date DATETIME NOT NULL,
  last_edit_date DATETIME NULL DEFAULT NULL,
  Category_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `Category_id`),
  UNIQUE INDEX name_UNIQUE (`name` ASC) VISIBLE,
  INDEX fk_Data_Category1_idx (`Category_id` ASC) VISIBLE,
  CONSTRAINT fk_Data_Category1
    FOREIGN KEY (`Category_id`)
    REFERENCES mydb.Category (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Comment
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Comment ;

CREATE TABLE IF NOT EXISTS mydb.Comment (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  contents VARCHAR(255) NOT NULL,
  creation_date DATETIME NOT NULL,
  User_id INT UNSIGNED NOT NULL,
  Data_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX fk_Comment_User1_idx (`User_id` ASC) VISIBLE,
  INDEX fk_Comment_Data1_idx (`Data_id` ASC) VISIBLE,
  CONSTRAINT fk_Comment_User1
    FOREIGN KEY (`User_id`)
    REFERENCES mydb.User (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Comment_Data1
    FOREIGN KEY (`Data_id`)
    REFERENCES mydb.Data (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Access
-- -----------------------------------------------------
DROP TABLE IF EXISTS mydb.Access ;

CREATE TABLE IF NOT EXISTS mydb.Access (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  access_type VARCHAR(32) NOT NULL,
  User_id INT UNSIGNED NOT NULL,
  Data_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX fk_Access_User1_idx (`User_id` ASC) VISIBLE,
  INDEX fk_Access_Data1_idx (`Data_id` ASC) VISIBLE,
  CONSTRAINT fk_Access_User1
    FOREIGN KEY (`User_id`)
    REFERENCES mydb.User (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_Access_Data1
    FOREIGN KEY (`Data_id`)
    REFERENCES mydb.Data (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Заповнення таблиці Role
INSERT INTO mydb.Role (`name`, `description`) VALUES('Admin', 'Administrator with full permissions'), ('Editor', 'User who can edit content'),('Viewer', 'User who can view content only');

-- Заповнення таблиці User
INSERT INTO mydb.User (`name`, password, email, account_creation_date, last_login_date, `Role_id`) VALUES ('Alice', 'password1', 'alice@example.com', '2024-11-01 10:00:00', '2024-11-26 14:00:00', 1),('Bob', 'password2', 'bob@example.com', '2024-11-02 11:00:00', NULL, 2), ('Charlie', 'password3', 'charlie@example.com', '2024-11-03 12:00:00', '2024-11-25 16:00:00', 3);

-- Заповнення таблиці Category
INSERT INTO mydb.Category (`name`, `description`) VALUES ('Technology', 'Articles about technology'), ('Science', 'Articles about science'),('History', 'Articles about history');

-- Заповнення таблиці Data
INSERT INTO mydb.Data (`name`, contents, upload_date, last_edit_date, `Category_id`) VALUES ('AI Basics', 'Introduction to Artificial Intelligence', '2024-11-10 10:00:00', NULL, 1),('Quantum Mechanics', 'Basics of quantum mechanics', '2024-11-12 11:30:00', '2024-11-15 14:00:00', 2), ('World War II', 'History of World War II', '2024-11-14 12:00:00', NULL, 3);

-- Заповнення таблиці CommentINSERT INTO mydb.Comment (`contents`, creation_date, User_id, `Data_id`) VALUES ('Great article!', '2024-11-16 13:00:00', 2, 1), ('Needs more details.', '2024-11-17 15:00:00', 3, 2),('Very informative.', '2024-11-18 16:30:00', 1, 3);

-- Заповнення таблиці Permission
INSERT INTO mydb.Permission (`name`, description, `Role_id`) VALUES ('Edit Data', 'Can edit content', 2),('View Data', 'Can view content only', 3), ('Manage Users', 'Can manage user accounts', 1);

-- Заповнення таблиці Session
INSERT INTO mydb.Session (`login_time`, logout_time, `User_id`) VALUES('2024-11-26 10:00:00', '2024-11-26 12:00:00', 1), ('2024-11-26 13:00:00', '2024-11-26 15:00:00', 2);

-- Заповнення таблиці Access
INSERT INTO mydb.Access (`access_type`, User_id, `Data_id`) VALUES ('Read', 3, 1), ('Write', 2, 2), ('Admin', 1, 3);

```

## RESTfull сервіс для управління даними

**main.py**
```python
from fastapi import FastAPI
from database import engine, Base
from route import router

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(router)
```

**database.py**
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = f"mysql+pymysql://root:password@127.0.0.1:3306/mydb"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
```

**datamodel.py**
```python
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
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
```

**schema.py**
```python
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
```

**route.py**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from datamodel import Data
from schema import DataCreate, DataResponse, DataPatch
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
    db_data = db.query(Data).filter(Data.id == data_id).first()
    if db_data is None:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")
    return db_data


@router.post("/data/", response_model=DataResponse)
async def create_data(data: DataCreate, db: Session = Depends(get_db)):
    if db.query(Data).filter(Data.name == data.name).first():
        raise HTTPException(status_code=400, detail="The data with this name already exists")

    db_data = Data(**data.dict())
    db.add(db_data)
    db.commit()
    db.refresh(db_data)
    return db_data


@router.put("/data/{data_id}", response_model=DataResponse)
async def update_data(data_id: int, data: DataCreate, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(Data.id == data_id).first()
    if not db_data:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    if db.query(Data).filter(Data.name == data.name, Data.id != data_id).first():
        raise HTTPException(status_code=400, detail="The data with this name already exists")

    for key, value in data.dict().items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data


@router.delete("/data/{data_id}", response_model=DataResponse)
async def delete_data(data_id: int, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(Data.id == data_id).first()
    if not db_data:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    db.delete(db_data)
    db.commit()
    return db_data


@router.patch("/data/{data_id}", response_model=DataResponse)
async def patch_data(data_id: int, data: DataPatch, db: Session = Depends(get_db)):
    db_data = db.query(Data).filter(Data.id == data_id).first()
    if not db_data:
        raise HTTPException(status_code=404, detail="The data with the specified ID was not found")

    updated_fields = data.dict(exclude_unset=True)
    for key, value in updated_fields.items():
        setattr(db_data, key, value)

    db.commit()
    db.refresh(db_data)
    return db_data
```

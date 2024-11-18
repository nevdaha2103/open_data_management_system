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
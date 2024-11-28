# SQL-скрипт

В цьому розділі розміщені сирцеві коди для створення бази даних.

```SQL
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

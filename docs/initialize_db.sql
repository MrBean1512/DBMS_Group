DROP database task_manager;

CREATE DATABASE task_manager;
USE task_manager;

CREATE TABLE color (
	color varchar(255) NOT NULL PRIMARY KEY,
    A int NOT NULL,
    R int NOT NULL,
    G int NOT NULL,
    B int NOT NULL
);

CREATE TABLE user(
	ID int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    password varchar(255) NOT NULL,
    username varchar(255) NOT NULL UNIQUE
);
CREATE TABLE category(
	ID int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ownerID int NOT NULL,
    name varchar(255) NOT NULL,
    color varchar(255) NOT NULL,
	FOREIGN KEY (ownerID) REFERENCES user(ID),
	FOREIGN KEY (color) REFERENCES color(color)
);
CREATE TABLE task (
	ID int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    ownerID int NOT NULL,
    description varchar(255) NOT NULL,
    dateTime datetime NOT NULL,
    completion bool NOT NULL,
    recurringID int NOT NULL,
    categoryID int NOT NULL,
    FOREIGN KEY (ownerID) REFERENCES user(ID),
    FOREIGN KEY (categoryID) REFERENCES category(ID)
);
CREATE TABLE share(
	categoryID int NOT NULL,
    userID int NOT NULL,
    ownerID int NOT NULL,
    FOREIGN KEY (ownerID) REFERENCES user(ID),
    FOREIGN KEY (userID) REFERENCES user(ID),
    FOREIGN KEY (categoryID) REFERENCES category(ID)
);
CREATE TABLE friend(
	userID int NOT NULL,
    friendID int NOT NULL,
    accepted bool NOT NULL,
	FOREIGN KEY (userID) REFERENCES user(ID),
	FOREIGN KEY (friendID) REFERENCES user(ID)
);

INSERT INTO color 
VALUES 
	("blue", 255, 164, 173, 233),
    ("green", 255, 131, 222, 196),
    ("red", 255, 255, 164, 142),
    ("orange", 255, 255, 198, 138),
    ("yellow", 255, 1, 1, 1),
    ("purple", 255, 1, 1, 1),
    ("magenta", 255, 1, 1, 1),
    ("lightblue", 255, 132, 223, 226);

INSERT INTO user (password, username)
VALUES
	("password", "admin"),
	("password", "frank"),
    ("cheese", "pswd: cheese");

INSERT INTO category (ownerID, name, color)
VALUES
	(1, "homework", "blue"),
    (1, "chores", "orange"),
    (1, "errands", "green"),
    (2, "generic", "blue");

INSERT INTO task (title, ownerID, description, dateTime, completion, recurringID, categoryID)
VALUES
	("take out trash", 1, " ", "2020-12-20 7:00:00", false, 1, 1),
	("cook pasta", 1, "no longer than 10 minutes", "2020-12-20 14:00:00", false, 1, 2),
    ("eat pasta", 1, "small bites", "2020-12-14 15:00:00", false, 1, 3),
    ("do homework", 1, "CS dbms pg 243 & 341", "2020-12-12 13:00:00", false, 1, 1),
    ("eat vegetables", 1, "I do not want to", "2020-12-13 2:00:00", false, 1, 2),
    ("frick?", 1, "this project is hard", "2020-12-12 2:00:00", false, 1, 1),
    ("guess what", 1, "your mom", "2020-12-13 22:00:00", false, 1, 3),
    ("sorry", 1, "that was a bad joke", "2020-12-12 20:00:00", false, 1, 2),
    ("I'm so tired", 1, "sleep will come soon", "2020-12-14 21:00:00", false, 1, 1),
    ("pick up trash", 1, " ", "2020-12-21 17:00:00", false, 1, 2),
	("take out trash", 2, "frank's task description", "2020-12-20 7:00:00", false, 1, 4),
	("cook pasta", 2, "frank's task description", "2020-12-20 14:00:00", false, 1, 4),
    ("eat pasta", 2, "frank's task description", "2020-12-14 15:00:00", false, 1, 4),
    ("do homework", 2, "frank's task description", "2020-12-12 13:00:00", false, 1, 4),
    ("eat vegetables", 2, "frank's task description", "2020-12-13 2:00:00", false, 1, 4),
    ("frick?", 2, "frank's task description", "2020-12-12 2:00:00", false, 1, 4),
    ("guess what", 2, "frank's task description", "2020-12-13 22:00:00", false, 1, 4),
    ("sorry", 2, "frank's task description", "2020-12-12 20:00:00", false, 1, 4),
    ("I'm so tired", 2, "frank's task description", "2020-12-14 21:00:00", false, 1, 4),
    ("pick up trash", 2, "frank's task description", "2020-12-21 17:00:00", false, 1, 4);
    
INSERT INTO share
VALUES
	(1, 2, 1),
    (2, 1, 1);
    
INSERT INTO friend
VALUES
	(1, 2, false),
    (2, 3, true);
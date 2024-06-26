DROP TABLE IF EXISTS UserWorkouts;
DROP TABLE IF EXISTS Workouts;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Birthday VARCHAR(255) NOT NULL,
    Goals TEXT
);

CREATE TABLE Workouts (
    WorkoutID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT NOT NULL,
    Type VARCHAR(255),
    BodyPart VARCHAR(255),
    Level VARCHAR(255),
    Equipment VARCHAR(255)
);

CREATE TABLE UserWorkouts (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    WorkoutID INT,
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (WorkoutID) REFERENCES Workouts(WorkoutID)
);
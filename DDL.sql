-- الجداول الأساسية

CREATE TABLE Driver (
    DriverID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Age INT CHECK (Age >= 18),
    LicenseNumber VARCHAR(20) UNIQUE NOT NULL,
    Rating DECIMAL(3,2) CHECK (Rating BETWEEN 0 AND 5),
    Availability VARCHAR(20) CHECK (Availability IN ('Available', 'Unavailable'))
);

CREATE TABLE Car (
    PlateNumber VARCHAR(15) PRIMARY KEY,
    Type VARCHAR(30) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Available', 'In Maintenance', 'Occupied')),
    FuelLevel DECIMAL(3,2) CHECK (FuelLevel BETWEEN 0 AND 1),
    DriverID INT UNIQUE,  -- علاقة 1:1 مع السائق
    FOREIGN KEY (DriverID) REFERENCES Driver(DriverID)
);

CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    RewardPoints INT DEFAULT 0 CHECK (RewardPoints >= 0)
);

-- الجداول المرتبطة

CREATE TABLE Ride (
    RideID SERIAL PRIMARY KEY,
    StartLocation VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP,
    Cost DECIMAL(10,2) CHECK (Cost >= 0),
    Status VARCHAR(20) CHECK (Status IN ('Completed', 'Cancelled', 'In Progress')),
    DriverID INT REFERENCES Driver(DriverID),
    PlateNumber VARCHAR(15) REFERENCES Car(PlateNumber)
);

CREATE TABLE RideCustomer (
    RideID INT REFERENCES Ride(RideID) ON DELETE CASCADE,
    CustomerID INT REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    PRIMARY KEY (RideID, CustomerID)
);

CREATE TABLE Payment (
    PaymentID SERIAL PRIMARY KEY,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Method VARCHAR(20) CHECK (Method IN ('Cash', 'Credit Card', 'Digital Wallet')),
    Date TIMESTAMP NOT NULL,
    RideID INT REFERENCES Ride(RideID),
    CustomerID INT REFERENCES Customer(CustomerID)
);

CREATE TABLE Complaint (
    ComplaintID SERIAL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Description TEXT,
    ResolutionStatus VARCHAR(50),
    FeedbackRating DECIMAL(3,2) CHECK (FeedbackRating BETWEEN 0 AND 5),
    CustomerID INT REFERENCES Customer(CustomerID),
    DriverID INT REFERENCES Driver(DriverID)
);
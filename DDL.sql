
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);


CREATE TABLE Manager (
    user_id INT PRIMARY KEY REFERENCES "User"(user_id)
);


CREATE TABLE Driver (
    user_id INT PRIMARY KEY REFERENCES "User"(user_id),
    age INT CHECK (age >= 18),
    license_number VARCHAR(30) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
    availability VARCHAR(20) CHECK (availability IN ('Available', 'Unavailable'))
);


CREATE TABLE Customer (
    user_id INT PRIMARY KEY REFERENCES "User"(user_id),
    reward_points INT DEFAULT 0 CHECK (reward_points >= 0)
);


CREATE TABLE Car (
    plate_number VARCHAR(15) PRIMARY KEY,
    type VARCHAR(30) NOT NULL,
    model VARCHAR(50) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Available', 'In Maintenance', 'Occupied')),
    fuel_level DECIMAL(3,2) CHECK (fuel_level BETWEEN 0 AND 1),
    driver_id INT UNIQUE REFERENCES Driver(user_id) -- علاقة 1:1 مع السائق
);


CREATE TABLE Ride (
    ride_id SERIAL PRIMARY KEY,
    start_location VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    cost DECIMAL(10,2) CHECK (cost >= 0),
    status VARCHAR(20) CHECK (status IN ('Completed', 'Cancelled', 'In Progress')),
    driver_id INT REFERENCES Driver(user_id),
    plate_number VARCHAR(15) REFERENCES Car(plate_number)
);


CREATE TABLE RideCustomer (
    ride_id INT REFERENCES Ride(ride_id) ON DELETE CASCADE,
    customer_id INT REFERENCES Customer(user_id) ON DELETE CASCADE,
    PRIMARY KEY (ride_id, customer_id)
);


CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(20) CHECK (method IN ('Cash', 'Credit Card', 'Digital Wallet')),
    date TIMESTAMP NOT NULL,
    ride_id INT REFERENCES Ride(ride_id),
    customer_id INT REFERENCES Customer(user_id)
);


CREATE TABLE Complaint (
    complaint_id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    resolution_status VARCHAR(50),
    feedback_rating DECIMAL(3,2) CHECK (feedback_rating BETWEEN 0 AND 5),
    customer_id INT REFERENCES Customer(user_id),
    driver_id INT REFERENCES Driver(user_id)
);

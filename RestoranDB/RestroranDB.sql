-- Table for Restaurants
CREATE TABLE Restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    working_hours VARCHAR(50) NOT NULL
);

-- Table for Menu
CREATE TABLE Menu (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    dish_name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('Appetizer', 'Main Course', 'Dessert')),
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    calories INT NOT NULL CHECK (calories > 0),
    available BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants (id) ON DELETE CASCADE
);

-- Table for Users
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    loyalty_card BOOLEAN NOT NULL DEFAULT FALSE
);

-- Table for Orders
CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    delivery_address TEXT,
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price > 0),
    order_type VARCHAR(50) NOT NULL CHECK (order_type IN ('Delivery', 'Dine-In')),
    order_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants (id) ON DELETE CASCADE
);

-- Table linking Orders and Dishes
CREATE TABLE Order_Dish (
    order_id INT NOT NULL,
    dish_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, dish_id),
    FOREIGN KEY (order_id) REFERENCES Orders (id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES Menu (id) ON DELETE CASCADE
);

-- Table for Staff
CREATE TABLE Staff (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('Chef', 'Waiter', 'Delivery Person')),
    age INT NOT NULL CHECK (age >= 18),
    driver_license BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants (id) ON DELETE CASCADE
);

-- Table for Ratings
CREATE TABLE Ratings (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders (id) ON DELETE CASCADE
);


SELECT dish_name, price FROM Menu WHERE price < 15;

SELECT * FROM Orders WHERE EXTRACT(YEAR FROM order_date) = 2023 AND total_price > 50;

SELECT first_name, last_name, COUNT(*) AS delivery_count 
FROM Staff
JOIN Orders ON Staff.id = Orders.restaurant_id
WHERE role = 'Delivery Person'
GROUP BY Staff.id
HAVING COUNT(*) > 100;
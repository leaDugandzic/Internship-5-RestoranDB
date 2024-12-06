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

COPY Restaurants (id, name, city, capacity, working_hours)
FROM './MOCK_DATA.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO Menu (id, dish_name, category, price, calories, available) VALUES
(1, 'Margherita Pizza', 'Main Course', 12.99, 250, TRUE),
(1, 'Caprese Salad', 'Appetizer', 8.99, 150, TRUE),
(1, 'Tiramisu', 'Dessert', 5.99, 300, TRUE),
(2, 'California Roll', 'Appetizer', 10.99, 180, TRUE),
(2, 'Spicy Tuna Roll', 'Main Course', 15.99, 250, TRUE),
(2, 'Matcha Cheesecake', 'Dessert', 7.99, 280, TRUE),
(3, 'Cheeseburger', 'Main Course', 9.99, 450, TRUE),
(3, 'Fries', 'Appetizer', 3.99, 250, TRUE),
(3, 'Milkshake', 'Dessert', 4.99, 350, TRUE),
(4, 'Beef Tacos', 'Main Course', 8.99, 350, TRUE);

INSERT INTO Users (first_name, last_name, address, loyalty_card) VALUES
('John', 'Doe', '123 Main St, New York', TRUE),
('Jane', 'Smith', '456 Oak Rd, San Francisco', FALSE),
('Emily', 'Johnson', '789 Pine Ln, Los Angeles', TRUE),
('Michael', 'Williams', '101 Maple Dr, Miami', FALSE),
('Sarah', 'Brown', '202 Cedar Ave, Chicago', TRUE),
('David', 'Davis', '303 Birch Blvd, Boston', FALSE),
('Linda', 'Miller', '404 Willow St, Dallas', TRUE),
('James', 'Wilson', '505 Elm Rd, Las Vegas', FALSE),
('Patricia', 'Moore', '606 Pine St, Houston', TRUE),
('Robert', 'Taylor', '707 Oak St, Seattle', FALSE);

INSERT INTO Orders (user_id, restaurant_id, delivery_address, total_price, order_type, order_date) VALUES
(1, 1, '123 Main St, New York', 28.97, 'Delivery', '2024-01-10 12:30:00'),
(2, 2, '456 Oak Rd, San Francisco', 32.97, 'Dine-In', '2024-01-11 13:45:00'),
(3, 3, '789 Pine Ln, Los Angeles', 24.97, 'Delivery', '2024-01-12 14:00:00'),
(4, 4, '101 Maple Dr, Miami', 19.98, 'Dine-In', '2024-01-13 15:30:00'),
(5, 5, '202 Cedar Ave, Chicago', 19.98, 'Delivery', '2024-01-14 16:00:00'),
(6, 6, '303 Birch Blvd, Boston', 25.98, 'Dine-In', '2024-01-15 17:10:00'),
(7, 7, '404 Willow St, Dallas', 21.98, 'Delivery', '2024-01-16 18:00:00'),
(8, 8, '505 Elm Rd, Las Vegas', 22.98, 'Dine-In', '2024-01-17 19:20:00'),
(9, 9, '606 Pine St, Houston', 22.97, 'Delivery', '2024-01-18 20:15:00'),
(10, 10, '707 Oak St, Seattle', 27.97, 'Dine-In', '2024-01-19 21:00:00');

INSERT INTO Order_Dish (order_id, dish_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 4, 1),
(2, 5, 1),
(3, 6, 2),
(3, 7, 1),
(4, 8, 2),
(4, 9, 1),
(5, 10, 2),
(5, 1, 1);

INSERT INTO Staff (restaurant_id, first_name, last_name, role, age, driver_license) VALUES
(1, 'Mario', 'Rossi', 'Chef', 38, TRUE),
(1, 'Anna', 'Bianchi', 'Waiter', 28, FALSE),
(2, 'Taro', 'Yamamoto', 'Chef', 42, TRUE),
(2, 'Suki', 'Tanaka', 'Waiter', 33, FALSE),
(3, 'Tom', 'Harris', 'Chef', 45, TRUE),
(3, 'Emily', 'Clark', 'Waiter', 25, TRUE),
(4, 'Carlos', 'Martinez', 'Chef', 36, TRUE),
(4, 'Julio', 'Garcia', 'Delivery Person', 30, TRUE),
(5, 'Laura', 'Nguyen', 'Chef', 32, TRUE),
(5, 'Rachel', 'Kim', 'Waiter', 27, FALSE);

INSERT INTO Ratings (user_id, order_id, rating, comment) VALUES
(1, 1, 5, 'Excellent pizza and fast delivery!'),
(2, 2, 4, 'Great sushi, but the service could improve.'),
(3, 3, 5, 'Loved the milkshake and fries!'),
(4, 4, 3, 'Tacos were good, but a bit too salty.'),
(5, 5, 5, 'Amazing vegetarian dishes!'),
(6, 6, 4, 'Nice place, but it was too noisy.'),
(7, 7, 5, 'Steak was perfect!'),
(8, 8, 2, 'Fries were soggy and cold.'),
(9, 9, 4, 'Great food, but delivery was slow.'),
(10, 10, 5, 'Fantastic steak and dessert!');


SELECT dish_name, price FROM Menu WHERE price < 15;

SELECT * FROM Orders WHERE EXTRACT(YEAR FROM order_date) = 2023 AND total_price > 50;

SELECT first_name, last_name, COUNT(*) AS delivery_count 
FROM Staff
JOIN Orders ON Staff.id = Orders.restaurant_id
WHERE role = 'Delivery Person'
GROUP BY Staff.id
HAVING COUNT(*) > 100;

SELECT first_name, last_name 
FROM Staff
JOIN Restaurants ON Staff.restaurant_id = Restaurants.id
WHERE role = 'Chef' AND Restaurants.city = 'Zagreb';

SELECT Restaurants.name, COUNT(Orders.id) AS order_count
FROM Orders
JOIN Restaurants ON Orders.restaurant_id = Restaurants.id
WHERE Restaurants.city = 'Split' AND EXTRACT(YEAR FROM order_date) = 2023
GROUP BY Restaurants.name;

SELECT Menu.dish_name, COUNT(Order_Dish.dish_id) AS order_count
FROM Order_Dish
JOIN Menu ON Order_Dish.dish_id = Menu.id
JOIN Orders ON Order_Dish.order_id = Orders.id
WHERE Menu.category = 'Dessert' AND EXTRACT(MONTH FROM Orders.order_date) = 12 
  AND EXTRACT(YEAR FROM Orders.order_date) = 2023
GROUP BY Menu.dish_name
HAVING COUNT(Order_Dish.dish_id) > 10;

SELECT COUNT(Orders.id) AS order_count
FROM Orders
JOIN Users ON Orders.user_id = Users.id
WHERE Users.last_name LIKE 'M%';

SELECT Restaurants.name, AVG(Ratings.rating) AS average_rating
FROM Ratings
JOIN Orders ON Ratings.order_id = Orders.id
JOIN Restaurants ON Orders.restaurant_id = Restaurants.id
WHERE Restaurants.city = 'Rijeka'
GROUP BY Restaurants.name;

FROM Restaurants
WHERE capacity > 30 AND id IN (SELECT restaurant_id FROM Staff WHERE role = 'Delivery Person');

DELETE FROM Menu
WHERE id NOT IN (
    SELECT dish_id 
    FROM Order_Dish
    JOIN Orders ON Order_Dish.order_id = Orders.id
    WHERE Orders.order_date > NOW() - INTERVAL '2 years'
);

UPDATE Users
SET loyalty_card = FALSE
WHERE id NOT IN (
    SELECT user_id 
    FROM Orders
    WHERE order_date > NOW() - INTERVAL '1 year'
);
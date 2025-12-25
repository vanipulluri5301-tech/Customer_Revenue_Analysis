CREATE TABLE dbo.Orders (
    OrderID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID   INT          NOT NULL,
    OrderDate    DATE         NOT NULL,
    OrderTotal   DECIMAL(10,2) NOT NULL,
    OrderStatus  VARCHAR(20)  NOT NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);


CREATE TABLE dbo.Payments (
    PaymentID     INT IDENTITY(1,1) PRIMARY KEY,
    OrderID       INT           NOT NULL,
    PaymentDate   DATE          NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(30)   NOT NULL,
    PaymentStatus VARCHAR(20)   NOT NULL,

    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
);


INSERT INTO dbo.Customers (FirstName, LastName, Email, Region, SignupDate)
VALUES
('John',   'Smith',   'john.smith@email.com',   'Northeast', '2023-01-15'),
('Maria',  'Garcia',  'maria.garcia@email.com', 'West',      '2023-03-02'),
('David',  'Johnson', 'david.johnson@email.com','Midwest',   '2023-05-18'),
('Priya',  'Patel',   'priya.patel@email.com',  'South',    '2023-07-09'),
('Chen',   'Li',      'chen.li@email.com',      'West',     '2023-09-21'),
('Emily',  'Brown',   'emily.brown@email.com',  'Northeast','2024-01-10');


INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderTotal, OrderStatus)
VALUES
(1, '2023-02-01', 120.50, 'Completed'),
(1, '2023-06-14', 340.00, 'Completed'),
(2, '2023-03-15', 89.99,  'Completed'),
(2, '2023-08-22', 450.75, 'Completed'),
(3, '2023-06-02', 210.00, 'Cancelled'),
(3, '2023-11-19', 325.40, 'Completed'),
(4, '2023-07-20', 150.00, 'Completed'),
(4, '2024-02-05', 600.00, 'Completed'),
(5, '2023-10-01', 275.25, 'Completed'),
(6, '2024-01-20', 95.00,  'Completed');


INSERT INTO dbo.Payments (OrderID, PaymentDate, PaymentAmount, PaymentMethod, PaymentStatus)
VALUES
-- Order 1
(1, '2023-02-01', 120.50, 'Credit Card', 'Success'),

-- Order 2
(2, '2023-06-14', 340.00, 'Credit Card', 'Success'),

-- Order 3
(3, '2023-03-15', 89.99, 'PayPal', 'Success'),

-- Order 4 (failed attempt then success)
(4, '2023-08-22', 450.75, 'Credit Card', 'Failed'),
(4, '2023-08-23', 450.75, 'Credit Card', 'Success'),

-- Order 5 (cancelled order – failed payment)
(5, '2023-06-02', 210.00, 'Debit Card', 'Failed'),

-- Order 6
(6, '2023-11-19', 325.40, 'Credit Card', 'Success'),

-- Order 7
(7, '2023-07-20', 150.00, 'Debit Card', 'Success'),

-- Order 8
(8, '2024-02-05', 600.00, 'Bank Transfer', 'Success'),

-- Order 9
(9, '2023-10-01', 275.25, 'PayPal', 'Success'),

-- Order 10
(10,'2024-01-20', 95.00, 'Credit Card', 'Success');


SELECT * FROM dbo.Customers
SELECT * FROM dbo.Orders
SELECT * FROM dbo.Payments

-- Total revenue per customer, ordered by highest spender
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Region,
    SUM(o.OrderTotal) AS TotalRevenue,
    COUNT(o.OrderID) AS TotalOrders
FROM dbo.Customers c
INNER JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Completed'  -- exclude cancelled orders
GROUP BY 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Region
ORDER BY TotalRevenue DESC;

--
SELECT 
    c.Region,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.OrderTotal) AS TotalRevenue,
    AVG(o.OrderTotal) AS AvgOrderValue
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Completed'  -- only consider completed orders
GROUP BY c.Region
ORDER BY TotalRevenue DESC;

-- Customer segmentation by total revenue
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Region,
    SUM(o.OrderTotal) AS TotalRevenue,
    CASE 
        WHEN SUM(o.OrderTotal) >= 500 THEN 'High Value'
        WHEN SUM(o.OrderTotal) >= 250 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerSegment
FROM dbo.Customers c
INNER JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Completed'  -- consider only completed orders
GROUP BY 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Region
ORDER BY TotalRevenue DESC;


SELECT 
    CAST(COUNT(DISTINCT o.OrderID) AS DECIMAL(10,2)) 
    / (SELECT COUNT(*) FROM dbo.Orders) * 100 AS FailedOrderPercentage
FROM dbo.Orders o
JOIN dbo.Payments p
    ON o.OrderID = p.OrderID
WHERE p.PaymentStatus = 'Failed';


-- Determine if repeat customers are more valuable
WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        COUNT(o.OrderID) AS OrderCount,
        SUM(o.OrderTotal) AS TotalRevenue
    FROM dbo.Customers c
    JOIN dbo.Orders o
        ON c.CustomerID = o.CustomerID
    WHERE o.OrderStatus = 'Completed'   -- Only include completed orders
    GROUP BY c.CustomerID, c.FirstName, c.LastName
),
CustomerType AS (
    SELECT
        CustomerID,
        TotalRevenue,
        CASE 
            WHEN OrderCount > 1 THEN 'Repeat'
            ELSE 'One-Time'
        END AS CustomerCategory
    FROM CustomerRevenue
)
SELECT
    CustomerCategory,
    COUNT(CustomerID) AS NumCustomers,
    SUM(TotalRevenue) AS TotalRevenue,
    ROUND(AVG(TotalRevenue), 2) AS AvgRevenuePerCustomer
FROM CustomerType
GROUP BY CustomerCategory;





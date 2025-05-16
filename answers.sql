Question !

WITH RECURSIVE SplitProducts AS (
    -- Base case: Extract the first product before the first comma (or the entire string if no comma)
    SELECT 
        OrderID,
        CustomerName,
        TRIM(CASE 
            WHEN POSITION(',' IN Products) > 0 
            THEN SUBSTRING(Products FROM 1 FOR POSITION(',' IN Products) - 1)
            ELSE Products
        END) AS Products,
        CASE 
            WHEN POSITION(',' IN Products) > 0 
            THEN TRIM(SUBSTRING(Products FROM POSITION(',' IN Products) + 1))
            ELSE ''
        END AS Remaining
    FROM ProductDetail
    WHERE Products IS NOT NULL AND Products != ''
    
    UNION ALL
    
    -- Recursive case: Process remaining products after the comma
    SELECT 
        OrderID,
        CustomerName,
        TRIM(CASE 
            WHEN POSITION(',' IN Remaining) > 0 
            THEN SUBSTRING(Remaining FROM 1 FOR POSITION(',' IN Remaining) - 1)
            ELSE Remaining
        END) AS Products,
        CASE 
            WHEN POSITION(',' IN Remaining) > 0 
            THEN TRIM(SUBSTRING(Remaining FROM POSITION(',' IN Remaining) + 1))
            ELSE ''
        END AS Remaining
    FROM SplitProducts
    WHERE Remaining != ''
)
SELECT 
    OrderID,
    CustomerName,
    Products
FROM SplitProducts
ORDER BY OrderID, Products;



QUESTION 2


-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert unique OrderID and CustomerName into Orders
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert OrderID, Product, and Quantity into OrderItems
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

DROP TABLE OrderDetails;

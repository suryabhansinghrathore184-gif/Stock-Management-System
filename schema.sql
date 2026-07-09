-- Database Setup and Constraints Modernization Script for Stock Management System
USE [stock mangement system];
GO

-- 1. CLEANUP LEGACY HEAP TABLES
IF EXISTS (SELECT * FROM sys.tables WHERE name = 's_sell') DROP TABLE s_sell;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'sell') DROP TABLE sell;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Purchase') DROP TABLE Purchase;
GO

-- 2. APPLY NOT NULL TO KEY COLUMNS
ALTER TABLE a_login ALTER COLUMN a_id VARCHAR(50) NOT NULL;
GO
ALTER TABLE NewCustomer ALTER COLUMN Id VARCHAR(50) NOT NULL;
GO
ALTER TABLE NewSupplier ALTER COLUMN supplierid VARCHAR(50) NOT NULL;
GO

-- 3. ADD PRIMARY KEYS
IF NOT EXISTS (SELECT * FROM sys.key_constraints WHERE name = 'PK_a_login')
BEGIN
    ALTER TABLE a_login ADD CONSTRAINT PK_a_login PRIMARY KEY (a_id);
END
GO

IF NOT EXISTS (SELECT * FROM sys.key_constraints WHERE name = 'PK_NewCustomer')
BEGIN
    ALTER TABLE NewCustomer ADD CONSTRAINT PK_NewCustomer PRIMARY KEY (Id);
END
GO

IF NOT EXISTS (SELECT * FROM sys.key_constraints WHERE name = 'PK_NewSupplier')
BEGIN
    ALTER TABLE NewSupplier ADD CONSTRAINT PK_NewSupplier PRIMARY KEY (supplierid);
END
GO

-- ADD MISSING COLUMNS FOR EXTENDED CUSTOMER & SUPPLIER MODULES
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'altmobile') ALTER TABLE NewCustomer ADD altmobile VARCHAR(50) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'companyname') ALTER TABLE NewCustomer ADD companyname VARCHAR(100) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'state') ALTER TABLE NewCustomer ADD state VARCHAR(100) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'postalcode') ALTER TABLE NewCustomer ADD postalcode VARCHAR(20) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'country') ALTER TABLE NewCustomer ADD country VARCHAR(100) NULL DEFAULT 'India';
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewCustomer') AND name = 'createddate') ALTER TABLE NewCustomer ADD createddate DATETIME NULL DEFAULT GETDATE();

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'pannumber') ALTER TABLE NewSupplier ADD pannumber VARCHAR(50) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'altnumber') ALTER TABLE NewSupplier ADD altnumber VARCHAR(50) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'state') ALTER TABLE NewSupplier ADD state VARCHAR(100) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'postalcode') ALTER TABLE NewSupplier ADD postalcode VARCHAR(20) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'country') ALTER TABLE NewSupplier ADD country VARCHAR(100) NULL DEFAULT 'India';
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'website') ALTER TABLE NewSupplier ADD website VARCHAR(100) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'bankdetails') ALTER TABLE NewSupplier ADD bankdetails VARCHAR(255) NULL;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('NewSupplier') AND name = 'createddate') ALTER TABLE NewSupplier ADD createddate DATETIME NULL DEFAULT GETDATE();
GO

-- 4. CREATE NEW MODULE TABLES
-- Create Categories Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        CategoryId INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName VARCHAR(100) NOT NULL UNIQUE,
        Description VARCHAR(255) NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Active'
    );
END
GO

-- Create Products Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    CREATE TABLE Products (
        ProductCode VARCHAR(50) PRIMARY KEY,
        ProductName VARCHAR(100) NOT NULL,
        CategoryId INT NOT NULL,
        SupplierId VARCHAR(50) NOT NULL,
        PurchasePrice DECIMAL(18,2) NOT NULL DEFAULT 0.00,
        SellingPrice DECIMAL(18,2) NOT NULL DEFAULT 0.00,
        Quantity INT NOT NULL DEFAULT 0,
        Barcode VARCHAR(50) NULL,
        Description VARCHAR(500) NULL,
        ProductImage VARCHAR(255) NULL,
        CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId) ON DELETE NO ACTION,
        CONSTRAINT FK_Products_NewSupplier FOREIGN KEY (SupplierId) REFERENCES NewSupplier(supplierid) ON DELETE NO ACTION
    );
END
GO

-- Create Purchases Table (relational transaction-safe)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Purchases')
BEGIN
    CREATE TABLE Purchases (
        PurchaseId INT IDENTITY(1001,1) PRIMARY KEY,
        SupplierId VARCHAR(50) NOT NULL,
        ProductCode VARCHAR(50) NOT NULL,
        Quantity INT NOT NULL,
        PurchasePrice DECIMAL(18,2) NOT NULL,
        PurchaseDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Purchases_NewSupplier FOREIGN KEY (SupplierId) REFERENCES NewSupplier(supplierid) ON DELETE NO ACTION,
        CONSTRAINT FK_Purchases_Products FOREIGN KEY (ProductCode) REFERENCES Products(ProductCode) ON DELETE NO ACTION
    );
END
GO

-- Create Sales Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Sales')
BEGIN
    CREATE TABLE Sales (
        SaleId INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber VARCHAR(50) NOT NULL,
        CustomerId VARCHAR(50) NOT NULL,
        ProductCode VARCHAR(50) NOT NULL,
        Quantity INT NOT NULL,
        SellingPrice DECIMAL(18,2) NOT NULL,
        Discount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
        GST DECIMAL(18,2) NOT NULL DEFAULT 18.00, -- Default GST rate (e.g. 18%)
        Total DECIMAL(18,2) NOT NULL,
        SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Sales_NewCustomer FOREIGN KEY (CustomerId) REFERENCES NewCustomer(Id) ON DELETE NO ACTION,
        CONSTRAINT FK_Sales_Products FOREIGN KEY (ProductCode) REFERENCES Products(ProductCode) ON DELETE NO ACTION
    );
END
GO

-- Create StockHistory Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockHistory')
BEGIN
    CREATE TABLE StockHistory (
        HistoryId INT IDENTITY(1,1) PRIMARY KEY,
        ProductCode VARCHAR(50) NOT NULL,
        ChangeType VARCHAR(50) NOT NULL, -- 'Purchase', 'Sale', 'Adjustment'
        Quantity INT NOT NULL,
        Remarks VARCHAR(255) NULL,
        ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_StockHistory_Products FOREIGN KEY (ProductCode) REFERENCES Products(ProductCode) ON DELETE NO ACTION
    );
END
GO

-- 5. CREATE DATABASE INDEXES FOR PERFORMANCE
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_CategoryId')
    CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_SupplierId')
    CREATE INDEX IX_Products_SupplierId ON Products(SupplierId);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Purchases_ProductCode')
    CREATE INDEX IX_Purchases_ProductCode ON Purchases(ProductCode);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Sales_InvoiceNumber')
    CREATE INDEX IX_Sales_InvoiceNumber ON Sales(InvoiceNumber);
GO

-- 6. SEED INITIAL TEST DATA FOR NEW MODULES
-- Insert Categories
IF (SELECT COUNT(*) FROM Categories) = 0
BEGIN
    INSERT INTO Categories (CategoryName, Description, Status) VALUES
    ('Electronics', 'Mobile phones, laptops, and gadgets', 'Active'),
    ('Clothing', 'Apparel and accessories', 'Active'),
    ('Groceries', 'Daily consumables and home goods', 'Active'),
    ('Office Supplies', 'Pens, notebooks, and folders', 'Active');
END
GO

-- Ensure at least admin exists
IF (SELECT COUNT(*) FROM a_login) = 0
BEGIN
    INSERT INTO a_login (a_id, a_password) VALUES ('admin', '123');
END
GO

-- Insert Products
IF (SELECT COUNT(*) FROM Products) = 0
BEGIN
    INSERT INTO Products (ProductCode, ProductName, CategoryId, SupplierId, PurchasePrice, SellingPrice, Quantity, Barcode, Description, ProductImage) VALUES
    ('PROD1001', 'Samsung Galaxy S23', 1, '101', 55000.00, 65000.00, 25, '8806094765412', 'Samsung Flagship Phone', NULL),
    ('PROD1002', 'Men Denim Jacket', 2, '102', 1200.00, 2000.00, 50, '4009087612345', 'Stylishly casual denim jacket', NULL),
    ('PROD1003', 'Whole Wheat Bread 400g', 3, '101', 35.00, 45.00, 10, '8901234567890', 'Fresh whole wheat sliced bread', NULL);
END
GO

-- Insert Purchases
IF (SELECT COUNT(*) FROM Purchases) = 0
BEGIN
    INSERT INTO Purchases (SupplierId, ProductCode, Quantity, PurchasePrice, PurchaseDate) VALUES
    ('101', 'PROD1001', 25, 55000.00, GETDATE()-5),
    ('102', 'PROD1002', 50, 1200.00, GETDATE()-4),
    ('101', 'PROD1003', 10, 35.00, GETDATE()-3);
END
GO

-- Insert Sales
IF (SELECT COUNT(*) FROM Sales) = 0
BEGIN
    INSERT INTO Sales (InvoiceNumber, CustomerId, ProductCode, Quantity, SellingPrice, Discount, GST, Total, SaleDate) VALUES
    ('INV-2026-0001', '101', 'PROD1001', 1, 65000.00, 1000.00, 18.00, 75520.00, GETDATE()-2), -- 64000 * 1.18 = 75520
    ('INV-2026-0002', '102', 'PROD1003', 2, 45.00, 0.00, 5.00, 94.50, GETDATE()-1); -- 90 * 1.05 = 94.50
END
GO

PRINT 'Database layout successfully upgraded with constraints, tables, indexes, and seed data!';

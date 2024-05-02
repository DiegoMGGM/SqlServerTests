CREATE DATABASE smcdb1 COLLATE Modern_spanish_ci_ai
GO

USE smcdb1
GO

CREATE TABLE Test (
	Code CHAR(20) PRIMARY KEY
);

/**/

CREATE DATABASE smcdb2 COLLATE Latin1_general_cs_as
GO

USE smcdb2
GO

/**/

-- Agregar campo CHAR
ALTER TABLE Test
ADD CampoCHAR CHAR(20);

-- Agregar campo NCHAR
ALTER TABLE Test
ADD CampoNCHAR NCHAR(20);

-- Agregar campo UniqueIdentifier
ALTER TABLE Test
ADD CampoUniqueIdentifier UNIQUEIDENTIFIER;

-- Agregar campo INT
ALTER TABLE Test
ADD CampoINT INT;

-- Agregar campo DOUBLE
ALTER TABLE Test
ADD CampoDOUBLE DOUBLE;

-- Agregar campo MONEY
ALTER TABLE Test
ADD CampoMONEY MONEY;

/**/

ALTER TABLE Test
ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

ALTER TABLE Test
ADD active BOOLEAN DEFAULT 1

ALTER TABLE Test
ADD priority INT DEFAULT 0

/**/

/**/

CREATE TABLE Countries (
    CountryId INT PRIMARY KEY,
    CountryName VARCHAR(50)
);

CREATE TABLE Address (
    AddressId INT PRIMARY KEY,
    StreetAddress VARCHAR(100),
    City VARCHAR(50),
    PostalCode VARCHAR(20),
    CountryId INT,
    FOREIGN KEY (CountryId) REFERENCES Countries(CountryId)
);

CREATE TABLE sales.InvoicesHeader (
    InvoiceId INT PRIMARY KEY,
    InvoiceDate DATE,
    CustomerId INT,
    AddressId INT,
    TaxBase DECIMAL(10, 2),
    TotalVat DECIMAL(10, 2),
    Total DECIMAL(10, 2),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
);

/**/

CREATE TABLE sales.InvoicesDetail (
    InvoiceId INT,
    RowNumber INT,
    ProductId INT,
    Description VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    Discount DECIMAL(5, 2),
    VatTypeId INT,
    TotalLine DECIMAL(10, 2),
    PRIMARY KEY (InvoiceId, RowNumber),
    FOREIGN KEY (InvoiceId) REFERENCES sales.InvoicesHeader(InvoiceId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (VatTypeId) REFERENCES VatTypes(VatTypeId)
);

/**/

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    AddressId INT,
	Name VARCHAR(50),
    FOREIGN KEY (AddressId) REFERENCES Address(AddressId)
);

CREATE TABLE Products (
    ProductId INT PRIMARY KEY,
	Name VARCHAR(50)
);

CREATE TABLE VatTypes(
    VatTypeId INT PRIMARY KEY,
	Percentage DECIMAL(5, 2)
);

/**/

-- Store Procedure to create 10000 invoices
USE smcdb1;
GO
BEGIN
IF OBJECT_ID ( 'Sales.InsertInvoices', 'P') IS NOT NULL
    DROP PROCEDURE Sales.InsertInvoices;
END
GO
CREATE PROCEDURE Sales.InsertInvoices
    @InvoicesNum INT,
    @MinInvoiceLines INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Counter INT = 0;
    WHILE @Counter < @InvoicesNum
    BEGIN
        DECLARE @InvoiceId UNIQUEIDENTIFIER = NEWID();
        DECLARE @CustomerId UNIQUEIDENTIFIER;
        DECLARE @AddressId UNIQUEIDENTIFIER;
        DECLARE @InvoiceDate DATETIME = DATEADD(DAY, ROUND(RAND() * 364, 0), '20240101');
        DECLARE @InvoiceLinesNum INT = ROUND(RAND() * 50, 0) + @MinInvoiceLines;
        SELECT TOP 1 @CustomerId = CustomerId FROM Sales.Customers ORDER BY NEWID();
        SELECT TOP 1 @AddressId = AddressId FROM Sales.Address ORDER BY NEWID();
        INSERT INTO Sales.InvoicesHeader (InvoiceId, InvoiceDate, CustomerId, AddressId, TaxBase, TotalVat, Total)
        VALUES (@InvoiceId, @InvoiceDate, @CustomerId, @AddressId, 0, 0, 0);
        WHILE @InvoiceLinesNum > 0
        BEGIN
            DECLARE @ProductId UNIQUEIDENTIFIER;
            DECLARE @ProductDesc NVARCHAR(100);
            DECLARE @Quantity INT = ROUND(RAND() * 100, 0) + 1;
            DECLARE @Price MONEY = ROUND(RAND() * 100, 2) + 0.01;
            DECLARE @Discount DECIMAL(5,2) = ROUND(RAND() * 100, 0);
            DECLARE @VatType INT;
            SELECT TOP 1 @ProductId = ProductId FROM Sales.Products ORDER BY NEWID();
            SELECT TOP 1 @VatType = VatTypeId FROM Sales.VatTypes ORDER BY NEWID();
            DECLARE curProducts CURSOR FOR
            SELECT Name FROM Sales.Products WHERE ProductId = @ProductId;
            OPEN curProducts;
            FETCH NEXT FROM curProducts INTO @ProductDesc;
            CLOSE curProducts;
            DEALLOCATE curProducts;
            INSERT INTO Sales.InvoicesDetail (InvoiceId, RowNumber, ProductId, [Description], Quantity, UnitPrice, Discount, VatTypeId, TotalLine)
            VALUES (@InvoiceId, @InvoiceLinesNum, @ProductId, @ProductDesc, @Quantity, @Price, @Discount, @VatType, 0);
            SET @InvoiceLinesNum = @InvoiceLinesNum - 1;
        END
        SET @Counter = @Counter + 1;
    END
END
GO

-- Execute procedure
USE smcdb1;
GO
EXECUTE Sales.InsertInvoices @InvoicesNum = 10000, @MinInvoiceLines = 50;

/**/

select id.VatTypeId Type, year(ih.InvoiceDate) Year, ih.Total TotalInvoices, ih.TotalVat TotalVat, id.Quantity Quantity, avg(ih.Total) AvgTotalinvoice, 'hola' StdevTotalInvoice 
from sales.InvoicesHeader ih 
inner join sales.InvoicesDetail id on ih.InvoiceId = id.InvoiceId
/*inner join dbo.VatTypes vt id.VatTypeId = vt.VatTypeId*/

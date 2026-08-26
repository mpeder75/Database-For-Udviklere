CREATE TABLE Products (
 id int IDENTITY(1,1) PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 category VARCHAR(50) NOT NULL,
 price DECIMAL(10, 2) NOT NULL,
 stock int DEFAULT 0 NOT NULL,
 supplier VARCHAR(100) NULL,
 discontinued BIT DEFAULT 0 NOT NULL,
 created_at DATE DEFAULT GETDATE() NOT NULL
)

INSERT INTO Products(name, category, price, stock, supplier, discontinued, created_at)
VALUES('Kaffekande','Køkken', 249.00, 14, 'NordicHome', 0,'2025-01-14'),
      ('Termokande','Køkken', 399.50, 0, 'NordicHome', 1,'2024-11-02'),
      ('Espressokop','Køkken', 79.95, 120, NULL, 0,'2025-03-21'),
      ('Kaffebønner 1kg','Kaffe', 189.00, 45, 'BeanBros', 0,'2025-05-09'),
      ('Filterkaffe 500g','Kaffe', 69.00, 200, 'BeanBros', 0,'2025-05-09'),
      ('Kaffekværn','Elektronik', 1299.00, 7, 'GrindTech', 0,'2024-08-30'),
      ('Espressomaskine','Elektronik', 4499.00, 3, 'GrindTech', 0,'2025-02-17'),
      ('Mælkeskummer','Elektronik', 549.00, 22, NULL, 1,'2024-06-11'),
      ('Kaffefilter x100','Kaffe', 39.50, 340, 'BeanBros', 0,'2025-06-01'),
      ('Krus, sort','Køkken', 59.00, 88, 'NordicHome', 0,'2025-04-05'),
      ('Krus, hvid','Køkken', 59.00, 0, 'NordicHome', 0,'2025-04-05'),
      ('Rensetabletter','Tilbehør', 129.00, 31, 'GrindTech', 0,'2025-07-19');


-- MS SQL Server - top 5 dyreste produkter
SELECT TOP 5 * FROM Products ORDER BY price DESC;

-- MS SQL Server (kræver ORDER BY)
SELECT * FROM Products ORDER BY price DESC OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- MS SQL Server alternativ
SELECT name + ' (' + category + ')' as Kænnetthhh FROM Products;

-- MS SQL Server (kantede parenteser)
CREATE TABLE test ([order] VARCHAR(50), [select] VARCHAR(50));
INSERT INTO test ([order], [select]) VALUES ('test1', 'test2');
SELECT [order], [select] FROM test;


-- Opgave 6.6 - Find dd i mssql
SELECT CAST(GETDATE() AS DATE);

-- Opgave 7.1 - Indsæt en ny række og få det genererede id at vide. 
-- Løs det i alle tre databaser, og få det til at ske i så få trin som muligt
INSERT INTO Products(name, category, price)
OUTPUT INSERTED.id
VALUES('Testprodukt', 'Test', 99.00);

-- Opgvae 7.2 - Erstat den manglende leverandør med teksten Ukendt i resultatet, uden at ændre på dataene. 
-- Der findes mindst tre kandidat-funktioner til det. Find dem, og afprøv alle tre i alle tre databaser.
SELECT name, ISNULL(supplier, 'Ukendt') FROM Products;

-- Opgave 7.3 - Søg efter produktet med navnet kaffekande, skrevet med lille k.
SELECT * FROM Products WHERE name = 'kaffekande';



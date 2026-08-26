-- Opgave 1
CREATE TABLE Products (
 id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
 name VARCHAR(100) NOT NULL,
 category VARCHAR(50) NOT NULL,
 price DECIMAL(10, 2) NOT NULL,
 stock int DEFAULT 0 NOT NULL,
 supplier VARCHAR(100) NULL,
 discontinued BOOLEAN DEFAULT false NOT NULL,
 created_at DATE DEFAULT CURRENT_DATE NOT NULL
)

-- Info om tabel datatyper, nullable, default etc.
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'products'
ORDER BY ordinal_position;


-- Opgave 2.1 - Indsæt eget produkt
INSERT INTO Products(name, category, price, stock, supplier, discontinued,created_at)
VALUES('Stegepande', 'Køkken', 499.00, 10, 'JamieOliver', false, '2026-01-08')


-- Opgave 2.2 - Indsæt Kenneths data i Product tabel
INSERT INTO Products(name, category, price, stock, supplier, discontinued,created_at)
VALUES('Kaffekande','Køkken', 249.00, 14, 'NordicHome', false,'2025-01-14'),
	  ('Termokande','Køkken', 399.50, 0, 'NordicHome', true,'2024-11-02'),
	  ('Espressokop','Køkken', 79.95, 120, NULL,false,'2025-03-21'),
	  ('Kaffebønner 1kg','Kaffe', 189.00, 45, 'BeanBros', false,'2025-05-09'),
	  ('Filterkaffe 500g','Kaffe', 69.00, 200, 'BeanBros', false,'2025-05-09'),
	  ('Kaffekværn','Elektronik', 1299.00, 7, 'GrindTech', false,'2024-08-30'),
	  ('Espressomaskine','Elektronik', 4499.00, 3, 'GrindTech', false,'2025-02-17'),
	  ('Mælkeskummer','Elektronik', 549.00, 22, NULL, true,'2024-06-11'),
	  ('Kaffefilter x100','Kaffe', 39.50, 340, 'BeanBros', false,'2025-06-01'),
	  ('Krus, sort','Køkken', 59.00, 88, 'NordicHome', false,'2025-04-05'),
	  ('Krus, hvid','Køkken', 59.00, 0, 'NordicHome', false,'2025-04-05'),
	  ('Rensetabletter','Tilbehør', 129.00, 31, 'GrindTech', false,'2025-07-19');

SELECT * FROM products;

-- Opgave 2.3 - Indsæt tuple med kun med name, category, price
INSERT INTO Products(name, category, price)
VALUES('Test','Køkken', 111.00)

Select * From Products Where name = 'Test'


-- Opgave 2.4 - Fremprovokér en fejl med vilje. Prøv at indsætte en række uden category
INSERT INTO Products(name)
VALUES('Kommer der fejl?')


-- Opgave 2.5 - Tæl rækkerne. Der skal være 14
Select Count(*) from Products


-- Opgave 3.1
Select * from Products

-- Opgave 3.2 - kun produktnavn, kategori, pris
Select name, category, price from Products

-- Opgave 3.3 - Det samme, men hvor de tre kolonner i resultatet hedder produkt, kategori og pris
Select name as Navn, category as Kategori, price as Pris from Products

-- Opgave 3.4 - En liste over produktnavne og deres lagerværdi, altså prisen ganget med antallet på lager. Lagerværdien skal have et sigende navn i resultatet
SELECT name, price * stock AS lagerværdi
FROM products;

-- Opgave 3.5 - En liste over hvilke kategorier der overhovedet findes, hvor hver kategori kun optræder én gang. Hvor mange er der?
SELECT DISTINCT category
FROM Products;
	
-- Opgave 3.6 - Alle produkter sorteret med det dyreste først
SELECT * FROM Products
ORDER BY price DESC;

-- Opgave 3.7 - Alle produkter sorteret på kategori i alfabetisk rækkefølge, og inden for hver kategori med det dyreste først
SELECT * FROM Products
ORDER BY category ASC, price DESC;

-- Opgave 3.8 - Produkter sorteret efter lagerværdi, højeste først. Prøv at sortere på det navn du gav lagerværdien i punkt 4, i stedet for at gentage udregningen. Virker det?
SELECT *, price * stock AS inventory_value
FROM Products
ORDER BY inventory_value DESC;

-- Opgave 3.9 - Kun de produkter hvis lagerværdi er over 10.000. Prøv først at filtrere på det navn du gav kolonnen, præcis som du lige gjorde i sorteringen. Skriv fejlbeskeden ned
SELECT *, price * stock AS inventory_value
FROM Products
WHERE inventory_value > 10000;

-- Opgave 3.10 - Skriv punkt 9 om, så den virker. Forklar derefter med én sætning, hvorfor sorteringen i punkt 8 accepterede navnet, når filtreringen i punkt 9 ikke gjorde
SELECT *, price * stock AS inventory_value
FROM Products
WHERE price * stock > 10000;

-- Opgave 4.1 Alle produkter der koster mere end 200
SELECT *
FROM Products
WHERE price > 200;

-- Opgave 4.2 Alle produkter i kategorien Kaffe
SELECT *
FROM Products
WHERE category = 'Kaffe';

-- Opgave 4.3 Alle produkter med en pris fra og med 50 til og med 300
SELECT * FROM Products
WHERE price BETWEEN 50 AND 300;

-- Opgave 4.4 Alle produkter der enten er i kategorien Kaffe eller Tilbehør
SELECT *
FROM Products
WHERE category IN ('Kaffe', 'Tilbehør');

-- Opgave 4.5 Alle produkter hvis navn indeholder kaffe et vilkårligt sted
SELECT *
FROM Products
WHERE name LIKE '%kaffe%';

-- Opgave 4.6 Alle produkter hvor leverandøren mangler
SELECT * FROM Products
WHERE supplier IS NULL;

-- Opgave 4.7 Alle produkter hvor leverandøren er kendt
SELECT *
FROM Products
WHERE supplier IS NOT NULL;
  
-- Opgave 4.8 Alle produkter der ikke er udgået, og som har mere end 20 på lager
SELECT *
FROM Products
WHERE discontinued = false
  AND stock > 20;
  
-- Opgave 4.9 Prøv at finde produkterne uden leverandør ved at sammenligne kolonnen 
-- med den manglende værdi ved hjælp af almindeligt lighedstegn. Hvor mange rækker giver det? Skriv ned hvorfor
SELECT *
FROM Products
WHERE supplier = NULL;

SELECT * FROM Products WHERE supplier is NULL;

-- Opgave 4.10 Skriv en query der finder alle produkter der er i kategorien Kaffe eller Køkken, 
-- og som koster mere end 200. Kør den derefter igen uden parenteser omkring den del der hører sammen. 
-- Sammenlign antallet af rækker og forklar forskellen
SELECT *
FROM Products
WHERE (category = 'Kaffe' OR category = 'Køkken')
  AND price > 200;



-- Opgave 5.1 Se før du ændrer. Skriv den query der viser præcis de rækker du vil ramme i næste punkt, 
-- altså alle produkter i kategorien Kaffe 
SELECT *
FROM Products
WHERE category = 'Kaffe';

-- Opgave 5.2 Sæt prisen 10 procent op for netop de produkter, med den samme filtrering som i punkt 1. Notér hvor mange rækker klienten siger der blev ændret, og tjek bagefter at det passer
UPDATE Products
SET price = price * 1.10
WHERE category = 'Kaffe';

SELECT *
FROM Products
WHERE category = 'Kaffe';

-- Opgave 5.3 Markér Mælkeskummer som udgået og sæt lagerbeholdningen til 0. Begge dele skal ske i ét statement
UPDATE Products
SET discontinued = true,
    stock = 0
WHERE name = 'Mælkeskummer';

SELECT *
FROM Products
WHERE name = 'Mælkeskummer';

-- Opgave 5.4 Læg 25 til lagerbeholdningen for alle produkter der har 0 på lager. 
-- Du skal ikke skrive et nyt tal, men regne videre på det der allerede står i kolonnen
UPDATE Products
SET stock = stock + 25
WHERE stock = 0;

-- Opgave 5.5 Slet det produkt du selv fandt på i øvelse 2, trin 3
DELETE FROM Products
WHERE name = 'Test';

-- Opgave 5.6 Slet alt indhold i tabellen — og fortryd det igen. 
-- Find ud af hvordan man starter en transaktion i din database, slet alle rækker, tæl rækkerne inde i transaktionen, 
-- rul tilbage, og tæl igen. Skriv begge tal ned
BEGIN;
DELETE FROM Products;
SELECT COUNT(*) AS antal_produkter
FROM Products;
ROLLBACK;
SELECT COUNT(*) AS antal_produkter
FROM Products;

-- opgave 6.2 - De fem dyreste produkter. Løs opgaven i alle tre databaser. 
-- Der findes ikke ét svar der virker alle tre steder 
-- find de forskellige formuleringer, og notér hvilken der bruges hvor
SELECT * FROM Products ORDER BY price DESC LIMIT 5;

-- Opgave 6.3 -- PostgreSQL og MySQL
SELECT * FROM Products ORDER BY price DESC LIMIT 5 OFFSET 5;


-- Opgave 6.4 - Standardoperator || (virker i PostgreSQL, men i MySQL betyder || "OR")
SELECT name || ' (' || category || ')' FROM Products;


-- Opgave 6.5 PostgreSQL (dobbelte anførselstegn)
CREATE TABLE test ("order" VARCHAR(50), "select" VARCHAR(50));
INSERT INTO test ("order", "select") VALUES ('test1', 'test2');
SELECT "order", "select" FROM test;


-- Opgave 6.6 - find dd i PostgreSQL
SELECT CURRENT_DATE;


-- Opgave 7.1 - Indsæt en ny række og få det genererede id at vide. 
-- Løs det i alle tre databaser, og få det til at ske i så få trin som muligt
INSERT INTO Products(name, category, price)
VALUES('Testprodukt', 'Test', 99.00)
RETURNING id;

-- Opgave 7.2 - COALESCE
SELECT name, COALESCE(supplier, 'Ukendt') FROM Products;


-- Opgave 7.3 - Søg efter produktet med navnet kaffekande, skrevet med lille k.
SELECT * FROM Products WHERE name = 'kaffekande';


-- Opgave 7.4 - Få den database der gav nul rækker til at finde produktet alligevel, uden at ændre på dataene i tabellen
SELECT * FROM Products WHERE LOWER(name) = 'kaffekande';





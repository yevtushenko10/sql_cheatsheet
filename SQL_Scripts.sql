CREATE DATABASE Demo
GO
USE Demo

CREATE TABLE Base
(
	Id INT CONSTRAINT PK_Id PRIMARY KEY IDENTITY(1,1), -- CONSTRAINT_PK (PRIMARY KEY)
	ClientName NVARCHAR(20) NOT NULL,
	FamilyName NVARCHAR(30) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL CONSTRAINT UQ_PhoneNumber UNIQUE,  -- CONSTRAINT_UQ (UNIQUE)
	BirthDate DATE NOT NULL,
	SalaryRate DECIMAL(6,2) NOT NULL, --#(MONEY better)
	[Address] NVARCHAR(50) NOT NULL CONSTRAINT DF_Address DEFAULT 'No info',  -- CONSTRAIN_DF (DEFAULT)

	CONSTRAINT CK_SalaryRate CHECK (SalaryRate > 2000 AND SalaryRate < 5000), -- CONSTRAINT_CK (CHECK)
	CONSTRAINT FK_ClientName FOREIGN KEY (ClientName) REFERENCES Clients ([Name]) ON DELETE CASCADE -- CONSTRAINT_FK (FOREIGN KEY)
);

	-- ClientName REFERENCES Clients (Id)	-- CONSTRAINT_FK (FOREIGN KEY)

	--ON DELETE CASCADE
	--ON DELETE NO ACTION
	--ON DELETE SET NULL
	--ON DELETE SET DEFAULT

--CASCADE : автоматично видаляє або змінює рядки із залежної таблиці під час видалення або зміни пов'язаних рядків у головній таблиці.

--NO ACTION : запобігає будь-яким діям у залежній таблиці при видаленні або зміні зв'язаних рядків у головній таблиці. 
--Тобто фактично якихось дій відсутні.

--SET NULL : при видаленні зв'язаного рядка з головної таблиці встановлює значення NULL для стовпця зовнішнього ключа.

--SET DEFAULT : при видаленні зв'язаного рядка з головної таблиці встановлює для стовпчика зовнішнього ключа значення за промовчанням, 
--яке задається за допомогою атрибута DEFAULT. Якщо для стовпця не встановлено значення за умовчанням, 
--то як нього застосовується значення NULL.

---
USE Demo
GO
CREATE TABLE Test
(
	Id INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(20) NOT NULL,
	Salary MONEY NOT NULL,
	Mark CHAR NOT NULL,	 --CHAR(1)
	CreatedAt DATE NOT NULL DEFAULT GETDATE()
);

SELECT * FROM Test

INSERT INTO Test([Name], Salary, Mark)
VALUES ('Alex', 3250.50, 'A');

-----------------------------------------------------
-- EXEC sp_

EXEC sp_rename 'Base.FamilyName', 'Surname', 'COLUMN'; -- Column
EXEC sp_rename 'Base', 'GO'; -- Table
EXEC sp_help;

---------------------------------------------------------------------
-- ALTER TABLE

ALTER TABLE Base
ALTER COLUMN BirthDate DATE NULL;

ALTER TABLE Base 
ADD Email NVARCHAR(30) NOT NULL CONSTRAINT UQ_Email UNIQUE;

ALTER TABLE Base WITH CHECK --(WITH NOCHECK)
ADD CONSTRAINT UQ_Address UNIQUE ([Address]);

--ALTER TABLE название_таблицы [WITH CHECK | WITH NOCHECK]
--{ DROP COLUMN название_столбца 
--  DROP [CONSTRAINT] имя_ограничения}
	
-- Додамо обмеження зовнішнього ключа до стовпця CustomerId таблиці Orders:
--ALTER TABLE Orders
--ADD FOREIGN KEY(CustomerId) REFERENCES Customers(Id);

-- Додавання первинного ключа
--ALTER TABLE Orders
--ADD PRIMARY KEY (Id);

-- Додавання обмежень з іменами
--ALTER TABLE Orders
--ADD CONSTRAINT PK_Orders_Id PRIMARY KEY (Id),
    --CONSTRAINT FK_Orders_To_Customers FOREIGN KEY(CustomerId) REFERENCES Customers(Id);

-- Видалення обмежень
--ALTER TABLE Orders
--DROP FK_Orders_To_Customers;

-------------------------------------------------------
-- INSERT INTO (Table_Name) VALUES

INSERT INTO Base (ClientName, Surname, PhoneNumber, BirthDate, SalaryRate, [Address], Email)
VALUES 
('Safaah', 'Afsfasashenko', '+386809758172406', '2006-06-10', 2501.00, 'Kosareva 21', 'sagvssamail.com'),
('Sasha', 'Afstushenko', '+3809758172406', '2006-06-10', 2001.00, 'Kosareva 20', 'sagvsswp84@gmail.com'),
('Oleh', 'Рevtushenko', '+3806558172406', '2004-06-10', 3000.00, 'Kosareva 19', 'sagewgwp84@gmail.com'),  
('Alex', 'Yevtushenko', '+380978172406', '2004-06-10', 3000.00, 'Kosareva 18', 'sashaggwp84@gmail.com');

--INSERT INTO Products
--DEFAULT VALUES   (if NULL of Default Value exist)

--INSERT INTO Products 
--VALUES
--('iPhone 6', 'Apple', 3, 36000),
--('iPhone 6S', 'Apple', 2, 41000),
--('iPhone 7', 'Apple', 5, 52000),
--('Galaxy S8', 'Samsung', 2, 46000),
--('Galaxy S8 Plus', 'Samsung', 1, 56000),
--('Mi6', 'Xiaomi', 5, 28000),
--('OnePlus 5', 'OnePlus', 6, 38000)

--------------------------------------------------------------
-- SELECT .. FROM

SELECT * FROM Base;

SELECT ClientName, Surname, SalaryRate FROM Base;

SELECT DISTINCT SalaryRate FROM Base;  -- only unique 

-- Оператор ORDER BY дозволяє відсортувати видобуті значення за певним стовпцем
SELECT * FROM Base
ORDER BY SalaryRate ASC

SELECT * FROM Base
ORDER BY SalaryRate DESC

SELECT ClientName, Surname, BirthDate FROM Base
ORDER BY BirthDate

-- Сортування також можна проводити за псевдонімом стовпця, який визначається за допомогою оператора AS
SELECT ProductName, Price, ProductCount, ProductCount * Price AS TotalSum 
FROM Sort
ORDER BY TotalSum;

CREATE TABLE SORT
(
	ProductName NVARCHAR (20),
	ProductCount INT,
	Price DECIMAL(6,2)
)

SELECT * FROM Sort;

INSERT INTO Sort (ProductName, ProductCount, Price)
VALUES 
('Iphone 7', 1, 300),
('Iphone 8', 2, 400),
('Iphone 10', 3, 600),
('Iphone 15', 5, 1100);

-- Оператор TOP дозволяє вибрати певну кількість рядків із таблиці
SELECT TOP 3 ClientName
FROM Base

-- Додатковий оператор PERCENT дозволяє вибрати відсоткову кількість рядків із таблиці. Наприклад, виберемо 75% рядків:
SELECT TOP 75 PERCENT Email
FROM Base

-- Оператор TOP дозволяє витягти певну кількість рядків, починаючи з початку таблиці. 
-- Для вилучення набору рядків з будь-якого місця застосовуються оператори OFFSET і FETCH . 
-- Важливо, що ці оператори застосовуються лише у відсортованому наборі даних після виразу ORDER BY.

-- Наприклад, виберемо всі рядки, починаючи з третього:
SELECT * FROM Base
ORDER BY Id 
OFFSET 2 ROWS;  -- skip

-- Тепер виберемо лише три рядки, починаючи з третього:
SELECT * FROM Base
ORDER BY Id 
OFFSET 1 ROWS  -- skip
FETCH NEXT 3 ROWS ONLY; -- take

-- Ця комбінація операторів зазвичай використовується для посторінкової навігації, коли необхідно отримати певну сторінку з даними.


-- = : порівняння на рівність (на відміну від сі-подібних мов у T-SQL для порівняння на рівність використовується один знак одно)

-- <>  порівняння нерівностей

-- <  менше ніж

-- >  більше ніж

-- !<  не менше ніж

-- !>  не більше ніж

-- <=  менше ніж або дорівнює

-- >=  більше ніж або одно

SELECT * FROM Base
WHERE SalaryRate > 2999
--
SELECT * FROM Base
WHERE Address = 'Kosareva 18';

-- AND : операція логічного І. Вона об'єднує два вирази

SELECT * FROM Base
WHERE ClientName = 'Alex' AND Surname = 'Yevtushenko';

-- OR : операція логічного АБО. Вона також поєднує два вирази

SELECT * FROM Base
WHERE SalaryRate > 2600 OR ClientName = 'Sasha';

-- NOT : операція логічного заперечення. Якщо вираз у цій операції помилкове, то загальна умова є істинною.

SELECT * FROM Products
WHERE NOT Manufacturer = 'Samsung'

-- v2
SELECT * FROM Products
WHERE Manufacturer <> 'Samsung'

--
SELECT * FROM Base
WHERE [Address] IS NULL;

--
SELECT * FROM Base
WHERE Email IS NOT NULL;

--
SELECT * FROM Products	
WHERE ProductCount !> 3;

--
SELECT * FROM Products	
WHERE ProductCount >= 3;


CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
 
INSERT INTO Products 
VALUES
('iPhone 6', 'Apple', 3, 36000),
('iPhone 6S', 'Apple', 2, 41000),
('iPhone 7', 'Apple', 5, 52000),
('Galaxy S8', 'Samsung', 2, 46000),
('Galaxy S8 Plus', 'Samsung', 1, 56000),
('Mi6', 'Xiaomi', 5, 28000),
('OnePlus 5', 'OnePlus', 6, 38000)

--
SELECT * FROM Products
WHERE Price * ProductCount > 200000

-- 
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' OR (Price > 30000 AND ProductCount > 2);

--
SELECT * FROM Products
WHERE (Manufacturer = 'Samsung' OR Price > 30000) AND ProductCount > 2

-------------------------------
-- Оператор IN дозволяє визначити набір значень, які мають стовпці:

SELECT * FROM Products
WHERE Manufacturer IN ('Samsung', 'Xiaomi', 'Huawei')

-- v2
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' OR Manufacturer = 'Xiaomi' OR Manufacturer = 'Huawei'

--
SELECT * FROM Products
WHERE Manufacturer NOT IN ('Samsung', 'Xiaomi', 'Huawei')

-- Оператор BETWEEN визначає діапазон значень за допомогою початкового та кінцевого значення, якому має відповідати вираз

SELECT * FROM Products
WHERE Price BETWEEN 20000 AND 40000
--
SELECT * FROM Products
WHERE Price NOT BETWEEN 20000 AND 40000
--
SELECT * FROM Products
WHERE Price * ProductCount BETWEEN 100000 AND 200000

-- Оператор LIKE приймає шаблон рядка, якому має відповідати вираз.
-- WHERE выражение [NOT] LIKE шаблон_строки

--Для визначення шаблону може застосовуватися ряд спеціальних символів підстановки:

--% : відповідає будь-якому підрядку, який може мати будь-яку кількість символів, при цьому підрядок може і не містити жодного символу

--_ : відповідає будь-якому одиночному символу

SELECT * FROM Base
WHERE Address LIKE 'Kosareva%';

SELECT * FROM Base
WHERE Surname LIKE '%nko%';

SELECT * FROM Base
WHERE [Address] LIKE 'Kosareva __';

SELECT * FROM Base
WHERE PhoneNumber NOT LIKE '+380%' OR Email NOT LIKE '%@%';

SELECT * FROM Base
WHERE [Address] LIKE 'Kosareva [1-2]%'

----------------------------------------------------
-- UPDATE

SELECT * FROM Base

UPDATE Base
SET SalaryRate = SalaryRate + 500;

UPDATE Base
SET SalaryRate = SalaryRate * 1.1;

UPDATE Base
SET ClientName = 'Dima'
WHERE Id = 4;

UPDATE Base
SET Surname = 'Gnatushenko', Email = 'hnatushenko@gmail.com'
WHERE Id = 4;

------------------------------------------------------------------------
-- DELETE / DROP / TRUNCATE

DELETE FROM Base
WHERE Surname = 'Yevtushenko';

DELETE FROM Base
WHERE SalaryRate = 3000;

DELETE Base;  -- delete the data from the table saving IDENTITY

TRUNCATE TABLE Base; -- same, but without saving IDENTITY

DROP TABLE Base;

--USE master;
--GO
--ALTER DATABASE Hillel SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--GO
DROP DATABASE Demo;

------------------------------------------------------------------------------------------
-- Агрегатні функції


--AVG : знаходить середнє значення

--SUM : знаходить суму значень

--MIN : знаходить найменше значення

--MAX : знаходить найбільше значення

--COUNT : знаходить кількість рядків у запиті

--Вирази у функціях AVG та SUM мають бути числовими. 
--Вираз у функціях MIN , MAX та COUNT може представляти числове чи рядкове значення чи дату.
--Усі агрегатні функції крім COUNT(*)ігнорують значення NULL.

SELECT * FROM Products
-- 	
SELECT AVG(Price) AS Average_Price FROM Products
--
SELECT AVG(Price) FROM Products
WHERE Manufacturer='Apple'
--	
SELECT AVG(Price * ProductCount) FROM Products
--
SELECT COUNT(*) FROM Products
--
SELECT COUNT(Manufacturer) FROM Products
--
SELECT MIN(Price) FROM Products
--
SELECT MAX(Price) FROM Products
--
SELECT SUM(ProductCount) FROM Products
--
SELECT SUM(ProductCount * Price) FROM Products
--
SELECT AVG(DISTINCT ProductCount) AS Average_Price FROM Products
--
SELECT AVG(ALL ProductCount) AS Average_Price FROM Products

--
SELECT * FROM Products

SELECT COUNT(*) AS ProdCount,
       SUM(ProductCount) AS TotalCount,
       MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice,
       AVG(Price) AS AvgPrice
FROM Products

----------------------------------------
-- Оператори GROUP BY та HAVING

--SELECT столбцы
--FROM таблица
--[WHERE условие_фильтрации_строк]
--[GROUP BY столбцы_для_группировки]
--[HAVING условие_фильтрации_групп]
--[ORDER BY столбцы_для_сортировки]


-- Оператор GROUP BY визначає, як рядки групуватимуться.
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer
ORDER BY ModelsCount

--
SELECT Manufacturer, ProductCount, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer, ProductCount

--Слід враховувати, що вираз GROUP BY має йти після виразу WHERE, але до виразу ORDER BY:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
WHERE Price > 30000
GROUP BY Manufacturer
ORDER BY ModelsCount DESC

--Фільтрування груп. HAVING
--Оператор HAVING визначає, які групи будуть включені у вихідний результат, тобто виконує фільтрацію груп.

--Застосування HAVING багато в чому аналогічне до застосування WHERE. 
--Тільки WHERE застосовується до фільтрації рядків, то HAVING використовується для фільтрації груп.

--Наприклад, знайдемо всі групи товарів за виробниками, для яких визначено понад 1 модель:

SELECT * FROM Products

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer
HAVING COUNT(*) > 1

-- При цьому в одній команді ми можемо використовувати вирази WHERE та HAVING:

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING COUNT(*) > 1

--Тобто в даному випадку спочатку фільтруються рядки: вибираються ті товари, загальна вартість яких більша за 80000. 
--Потім вибрані товари групуються за виробниками. І далі фільтруються самі групи - вибираються ті групи, які містять понад 1 модель.

--Якщо при цьому необхідно провести сортування, вираз ORDER BY йде після виразу HAVING:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING SUM(ProductCount) > 2
ORDER BY Units DESC

--В даному випадку угруповання йде по виробниках, а також вибирається кількість моделей для кожного виробника (Models) 
--та загальна кількість усіх товарів по всіх цих моделях (Units). Наприкінці групи сортуються за кількістю товарів зі спадання.

--------------
-- Розширення SQL Server для групування

-- Додатково до стандартних операторів GROUP BY і HAVING SQL Server 
-- Оператор ROLLUP додає рядок, що підсумовує, в результуючий набір:

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer WITH ROLLUP

---------------------------------------------------------------------------
-- Функції для роботи з рядками

--Для роботи з рядками у T-SQL можна застосовувати такі функції:

--LEN : повертає кількість символів у рядку. Як параметр у функцію передається рядок, для якого треба знайти довжину:
SELECT LEN('Apple')  -- 5

--LTRIM : видаляє початкові пробіли з рядка. Як параметр приймає рядок:
SELECT LTRIM('  Apple')

--RTRIM : видаляє кінцеві пропуски з рядка. Як параметр приймає рядок:
SELECT RTRIM(' Apple    ')

--CHARINDEX : повертає індекс, за яким знаходиться перше входження підрядка в рядку. 
SELECT CHARINDEX('pl', 'Apple') -- 3

--PATINDEX : повертає індекс, яким знаходиться перше входження певного шаблону в рядку:
SELECT PATINDEX('%p_e%', 'Apple')   -- 3

--LEFT : вирізує з початку рядка певну кількість символів. Перший параметр функції – рядок, а другий – кількість символів, які треба вирізати спочатку рядки:
SELECT LEFT('Apple', 3) -- App

--RIGHT : вирізує з кінця рядка певну кількість символів. Перший параметр функції – рядок, а другий – кількість символів, які треба вирізати спочатку рядки:
SELECT RIGHT('Apple', 3)    -- ple

--SUBSTRING : вирізає з рядка підрядок певною довжиною, починаючи з певного індексу. Співаний параметр функції - рядок, другий - початковий індекс для вирізки, і третій параметр - кількість символів, що вирізуються:
SELECT SUBSTRING('Galaxy S8 Plus', 8, 2)    -- S8

--REPLACE : замінює один підрядок на інший в рамках рядка. Перший параметр функції - рядок, другий - підрядок, який треба замінити, а третій - підрядок, на який треба замінити:
SELECT REPLACE('Galaxy S8 Plus', 'S8 Plus', 'Note 8')   -- Galaxy Note 8

--REVERSE : перевертає рядок навпаки:
SELECT REVERSE('123456789') -- 987654321

--CONCAT : об'єднує два рядки в один. Як параметр приймає від 2-х і більше рядків, які треба з'єднати:
SELECT CONCAT('Tom', ' ', 'Smith')  -- Tom Smith

--LOWER : перекладає рядок у нижній регістр:
SELECT LOWER('Apple')   -- apple

--UPPER : перекладає рядок у верхній регістр
SELECT UPPER('Apple')   -- APPLE

--SPACE : повертає рядок, який містить певну кількість прогалин
SELECT * FROM Base

SELECT ClientName + SPACE(2) + Surname AS FullName 
FROM Base
WHERE Id = 1;
--
SELECT * FROM Products

SELECT UPPER(LEFT(Manufacturer,2)) AS Abbreviation,
       CONCAT(ProductName, ' - ',  Manufacturer) AS FullProdName
FROM Products
ORDER BY Abbreviation DESC 

-----------------------------------------------------------------------------------------
--Для роботи з числовими даними T-SQL надає низку функцій:

--ROUND : Заокруглює число.
SELECT ROUND(1342.345, 2)   -- 1342.350

--ISNUMERIC : визначає, чи є значення числом. 
SELECT ISNUMERIC(1342.345)          -- 1
SELECT ISNUMERIC('1342.345')        -- 1
SELECT ISNUMERIC('SQL')         -- 0
SELECT ISNUMERIC('13-04-2017')  -- 0

--ABS : повертає абсолютне значення числа.
SELECT ABS(-123)    -- 123

--CEILING : повертає найменше ціле число, яке більше або дорівнює поточному значенню.
SELECT CEILING(-123.45)     -- -123
SELECT CEILING(123.45)      -- 124

--FLOOR : повертає найбільше ціле число, яке менше або дорівнює поточному значенню.
SELECT FLOOR(-123.45)       -- -124
SELECT FLOOR(123.45)        -- 123

--SQUARE : зводить число квадрат.
SELECT SQUARE(5)        -- 25

--SQRT : отримує квадратний корінь числа.
SELECT SQRT(225)        -- 15

--RAND : генерує випадкове число з точкою, що плаває, в діапазоні від 0 до 1.
SELECT RAND()       -- 0.707365088352935
SELECT RAND()       -- 0.173808327956812

---
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);

--Округлимо добуток ціни товару на кількість цього товару:

SELECT * FROM Products

SELECT ProductName, ROUND(Price * ProductCount, 2)
FROM Products

------------------------------------------------------------------------------------
-- Функції по роботі з датами та часом


--GETDATE : повертає поточну локальну дату та час на основі системного годинника у вигляді об'єкта datetime
SELECT GETDATE()    -- 2017-07-28 21:34:55.830

--GETUTCDATE : повертає поточну локальну дату та час за гринвічем (UTC/GMT) у вигляді об'єкта datetime
SELECT GETUTCDATE()     -- 2017-07-28 18:34:55.830

--SYSDATETIME : повертає поточну локальну дату та час на основі системного годинника, але відмінність від GETDATE полягає в тому, що дата та час повертаються у вигляді об'єкта datetime2
SELECT SYSDATETIME()        -- 2017-07-28 21:02:22.7446744

--SYSUTCDATETIME : повертає поточну локальну дату та час за гринвічем (UTC/GMT) у вигляді об'єкта datetime2
SELECT SYSUTCDATETIME()		-- 2017-07-28 18:20:27.5202777

--SYSDATETIMEOFFSET : повертає об'єкт datetimeoffset(7), який містить дату та час щодо GMT
SELECT SYSDATETIMEOFFSET()      -- 2017-07-28 21:02:22.7446744 +03:00

--DAY : повертає день дати, який передається як параметр
SELECT DAY(GETDATE())       -- 28

--MONTH : повертає місяць дати
SELECT MONTH(GETDATE())     -- 7

--YEAR : повертає рік з дати
SELECT YEAR(GETDATE())      -- 2017

--DATEDIFF : повертає різницю між двома датами. 
SELECT DATEDIFF(year, '2017-7-28', '2018-9-28')     -- разница 1 год
SELECT DATEDIFF(month, '2017-7-28', '2018-9-28')    -- разница 14 месяцев
SELECT DATEDIFF(day, '2017-7-28', '2018-9-28')      -- разница 427 дней

--TODATETIMEOFFSET : повертає значення datetimeoffset, яке є результатом складання тимчасового зміщення з об'єктом datetime2
SELECT TODATETIMEOFFSET('2017-7-28 01:10:22', '+03:00')

--SWITCHOFFSET : повертає значення datetimeoffset, яке є результатом складання тимчасового зміщення з іншим об'єктом datetimeoffset
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02:30')

--EOMONTH : повертає дату останнього дня для місяця, який використовується в переданій даті.
SELECT EOMONTH('2017-02-05')    -- 2017-02-28
SELECT EOMONTH('2017-02-05', 3) -- 2017-05-31

--DATEFROMPARTS : за роком, місяцем та днем ​​створює дату
SELECT DATEFROMPARTS(2017, 7, 28)       -- 2017-07-28

--ISDATE : перевіряє, чи є вираз датою. Якщо є, то повертає 1 інакше повертає 0.
SELECT ISDATE('2017-07-28')     -- 1
SELECT ISDATE('2017-28-07')     -- 0
SELECT ISDATE('28-07-2017')     -- 0
SELECT ISDATE('SQL')            -- 0

---
CREATE TABLE Orders
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,
    CreatedAt DATE NOT NULL DEFAULT GETDATE(),
    ProductCount INT DEFAULT 1,
    Price MONEY NOT NULL
);

-- Вираз DEFAULT GETDATE() вказує, що якщо при додаванні даних не передається дата,
-- вона автоматично обчислюється за допомогою функції GETDATE().

SELECT * FROM Orders

INSERT INTO Orders (ProductId, CustomerId, ProductCount, Price)
VALUES (1, 1, 5, 10)

-------------------------------------------------------------------------------------

-- Виконання підзапитів

-- T-SQL підтримує функціональність підзапитів (subquery), тобто таких запитів, які можуть бути вбудовані в інші запити.

create database productsdb
go
USE productsdb;
 
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
CREATE TABLE Customers
(
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL
);
CREATE TABLE Orders
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
    CustomerId INT NOT NULL REFERENCES Customers(Id) ON DELETE CASCADE,
    CreatedAt DATE NOT NULL,
    ProductCount INT DEFAULT 1,
    Price MONEY NOT NULL
);
--
INSERT INTO Products 
VALUES ('iPhone 6', 'Apple', 2, 36000),
('iPhone 6S', 'Apple', 2, 41000),
('iPhone 7', 'Apple', 5, 52000),
('Galaxy S8', 'Samsung', 2, 46000),
('Galaxy S8 Plus', 'Samsung', 1, 56000),
('Mi 5X', 'Xiaomi', 2, 26000),
('OnePlus 5', 'OnePlus', 6, 38000)
 
INSERT INTO Customers VALUES ('Tom'), ('Bob'),('Sam')
 
INSERT INTO Orders 
VALUES
( 
    (SELECT Id FROM Products WHERE ProductName='Galaxy S8'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-11',  
    2, 
    (SELECT Price FROM Products WHERE ProductName='Galaxy S8')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 6S'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-13',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 6S')
),
( 
    (SELECT Id FROM Products WHERE ProductName='iPhone 6S'), 
    (SELECT Id FROM Customers WHERE FirstName='Bob'),
    '2017-07-11',  
    1, 
    (SELECT Price FROM Products WHERE ProductName='iPhone 6S')
)

SELECT * FROM Products
SELECT * FROM Customers
SELECT * FROM Orders

SELECT *
FROM Products
WHERE Price = (SELECT MIN(Price) FROM Products)

--
SELECT *
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)

--
SELECT * FROM Products
WHERE Price < ANY(SELECT Price FROM Products WHERE Manufacturer='Apple')

-- or
SELECT * FROM Products
WHERE Price < (SELECT MAX(Price) FROM Products WHERE Manufacturer='Apple')

-- Підзапит як специфікація стовпця
SELECT *, 
(SELECT ProductName FROM Products WHERE Id=Orders.ProductId) AS Product 
FROM Orders

-- Підзапити у команді INSERT
INSERT INTO Orders (ProductId, CustomerId, CreatedAt, ProductCount, Price)
VALUES
( 
    (SELECT Id FROM Products WHERE ProductName='Galaxy S8'), 
    (SELECT Id FROM Customers WHERE FirstName='Tom'),
    '2017-07-11',  
    2, 
    (SELECT Price FROM Products WHERE ProductName='Galaxy S8')
)

-- Підзапити у команді UPDATE 

UPDATE Orders
SET Price = (SELECT Price FROM Products WHERE Id=Orders.ProductId) + 2000
WHERE Id=1

-- Підзапити у команді DELETE
DELETE FROM Orders
WHERE ProductId=(SELECT Id FROM Products WHERE ProductName='Galaxy S8')
AND CustomerId=(SELECT Id FROM Customers WHERE FirstName='Bob')

-------------
-- WHERE [NOT] EXISTS (Sub-Query)

-- Наприклад, знайдемо всіх покупців із таблиці Customer, які робили замовлення:
SELECT * FROM Customers
WHERE EXISTS (SELECT * FROM Orders WHERE Orders.CustomerId = Customers.Id)

-- Інший приклад - знайдемо всі товари з таблиці Products, на які не було замовлень у таблиці Orders:
SELECT * FROM Products
WHERE NOT EXISTS (SELECT * FROM Orders WHERE Products.Id = Orders.ProductId)

-- Варто зазначити, що для отримання подібного результату могли б використовувати і опеатор IN :
SELECT * FROM Products
WHERE Id NOT IN (SELECT ProductId FROM Orders)

--  ISNULL 
SELECT * FROM Products

SELECT ProductName, Manufacturer,
        ISNULL(Phone, 'не определено') AS Phone,
        ISNULL(Email, 'неизвестно') AS Email
FROM Products

-------------------------------------------------------------------

-- Псевдонимы AS

SELECT C.FirstName, P.ProductName, O.CreatedAt 
FROM Orders AS O, Customers AS C, Products AS P
WHERE O.CustomerId = C.Id AND O.ProductId=P.Id

------------

-- INNER JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers 
JOIN Orders ON Orders.CustomerId = Customers.Id
 
--LEFT JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers 
LEFT JOIN Orders ON Orders.CustomerId = Customers.Id

--RIGHT JOIN
SELECT * FROM Orders 
RIGHT JOIN Customers ON Orders.CustomerId = Customers.Id

SELECT * FROM Customers
SELECT * FROM Orders

-- Cross Join
SELECT * FROM Orders CROSS JOIN Customers

-- При неявному перехресному з'єднанні можна опустити оператор CROSS JOIN і просто перерахувати всі таблиці:
SELECT * FROM Orders, Customers
--
SELECT Customers.FirstName, Orders.CreatedAt, Products.ProductName, Products.Manufacturer
FROM Orders 
JOIN Products ON Orders.ProductId = Products.Id AND Products.Price < 45000
LEFT JOIN Customers ON Orders.CustomerId = Customers.Id
ORDER BY Orders.CreatedAt
--
SELECT Products.ProductName, Products.Manufacturer, SUM(Orders.ProductCount * Orders.Price) AS Units
FROM Products 
LEFT JOIN Orders ON Orders.ProductId = Products.Id
GROUP BY Products.Id, Products.ProductName, Products.Manufacturer

--------------------------

-- UNION SELECT 

SELECT FirstName, LastName 
FROM Customers1
UNION SELECT FirstName, LastName FROM Employees
--
SELECT FirstName + ' ' +LastName AS FullName
FROM Customers1
UNION ALL SELECT FirstName + ' ' + LastName AS EmployeeName   -- ALL with Duplicates
FROM Employees
ORDER BY FullName DESC

-- EXCEPT SELECT

SELECT FirstName, LastName
FROM Customers1
EXCEPT SELECT FirstName, LastName
FROM Employees

-- INTERSECT SELECT

SELECT FirstName, LastName
FROM Employees
INTERSECT SELECT FirstName, LastName 
FROM Customers1

----------------
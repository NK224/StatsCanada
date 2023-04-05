Select *
from StatsCanadaMs..Census2021

Select *
from StatsCanadaMs..Categories


/* Creating new Column Parent ID as P_ID */

USE StatsCanadaMs;
ALTER TABLE Categories
ADD P_ID FLOAT;




/* Creating main Table for all main Categories as Main_Ch*/
CREATE TABLE Main_Ch (
    CHARACTERISTIC_ID FLOAT,
    CHARACTERISTIC_NAME VARCHAR(255),
    Main_Characteristic VARCHAR(255),
    P_ID FLOAT
);

INSERT INTO Main_Ch (CHARACTERISTIC_ID, CHARACTERISTIC_NAME, Main_Characteristic, P_ID)
    SELECT CHARACTERISTIC_ID, CHARACTERISTIC_NAME,Main_Characteristic,P_ID
    FROM Categories
    WHERE Counter = 0;

UPDATE Main_Ch
SET Main_Characteristic = Categories.Main_Characteristic,
	P_ID =Categories.P_ID
	
FROM Main_Ch
JOIN Categories ON Main_Ch.CHARACTERISTIC_ID = Categories.CHARACTERISTIC_ID;



/*Updating Parent Child relationship in Categories file
 and Creating a loop to update Parent ID P_ID in Categories Table*/

DECLARE @n INT = 2631; -- set the value of n to the maximum value of Characteristic_ID

DECLARE @i INT = 1; -- initialize the loop variable i to 1
DECLARE @S0 INT = NULL; -- initialize the variables S0, S1, S2, S3, and S4 to NULL
DECLARE @S1 INT = NULL; 
DECLARE @S2 INT = NULL;
DECLARE @S3 INT = NULL;
DECLARE @S4 INT = NULL;

WHILE @i <= @n
BEGIN
    -- update the P_ID, S0, S1, S2, S3, and S4 variables based on the value of Counter and Characteristic_ID
    UPDATE Categories
    SET
        P_ID = CASE
            WHEN Counter = 0 THEN NULL
            WHEN Counter = 1 THEN @S0
            WHEN Counter = 2 THEN @S1
            WHEN Counter = 3 THEN @S2
            WHEN Counter = 4 THEN @S3
            WHEN Counter = 5 THEN @S4
        END,
        @S0 = CASE
            WHEN Counter = 0 THEN CHARACTERISTIC_ID
            ELSE @S0
        END,
        @S1 = CASE
            WHEN Counter = 1 THEN CHARACTERISTIC_ID
            ELSE @S1
        END,
        @S2 = CASE
            WHEN Counter = 2 THEN CHARACTERISTIC_ID
            ELSE @S2
        END,
        @S3 = CASE
            WHEN Counter = 3 THEN CHARACTERISTIC_ID
            ELSE @S3
        END,
        @S4 = CASE
            WHEN Counter = 4 THEN CHARACTERISTIC_ID
            ELSE @S4
        END
    WHERE CHARACTERISTIC_ID = @i; -- update only the rows where Characteristic_ID matches the loop variable i
    
    SET @i = @i + 1; -- increment the loop variable i by 1
END;


/* Checking unique values in Each Column */
Select *
from StatsCanadaMS..Census2021

SELECT COUNT(DISTINCT GEO_NAME) AS unique_count
FROM StatsCanadaMs..Census2021











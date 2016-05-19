ALTER TABLE Race 
ADD COLUMN prix DECIMAL(7,2) UNSIGNED;

ALTER TABLE Espece 
ADD COLUMN prix DECIMAL(7,2) UNSIGNED;

-- Remplissage des colonnes "prix"
UPDATE Espece SET prix = 200 WHERE id = 1;
UPDATE Espece SET prix = 150 WHERE id = 2;
UPDATE Espece SET prix = 140 WHERE id = 3;
UPDATE Espece SET prix = 700 WHERE id = 4;
UPDATE Espece SET prix = 10 WHERE id = 5;
UPDATE Espece SET prix = 75 WHERE id = 6;

UPDATE Race SET prix = 450 WHERE id = 1;
UPDATE Race SET prix = 900 WHERE id = 2;
UPDATE Race SET prix = 950 WHERE id = 3;
UPDATE Race SET prix = 800 WHERE id = 4;
UPDATE Race SET prix = 700 WHERE id = 5;
UPDATE Race SET prix = 1200 WHERE id = 7;
UPDATE Race SET prix = 950 WHERE id = 8;
UPDATE Race SET prix = 600 WHERE id = 9;
SELECT nom FROM animal, espece
WHERE animal.espece_id = espece.id
AND espece.nom_courant = 'Chien'
AND MOD(CHAR_LENGTH(nom),2)=0
;

SELECT COALESCE(nom_courant,'TOTAL'),COUNT(nom) As nb
FROM animal 
INNER JOIN espece ON animal.espece_id=espece.id 
GROUP BY nom_courant
HAVING nb > 10;

SELECT COUNT(*) FROM race;

SELECT date_naissance
FROM animal
WHERE sexe='F'
ORDER BY date_naissance
LIMIT 1;

SELECT MAX(date_naissance)
FROM animal
WHERE sexe='F';


SELECT COALESCE(nom_courant,'TOTAL'), ROUND(AVG(prix),2)
FROM espece
WHERE nom_courant='Chat' OR nom_courant='Chien'
GROUP BY nom_courant WITH ROLLUP;

/*
SELECT Animal.id, Animal.nom, Animal.date_naissance, Race.nom as race, COALESCE(Race.prix, Espece.prix) as prix

Je rappelle que la fonction COALESCE() prend un nombre illimité de paramètres, et renvoie le premier paramètre non NULL qu'elle rencontre. 
Donc ici, s'il s'agit d'un chat de race, Race.prix ne sera pas NULL et sera donc renvoyé. 
Par contre, s'il n'y a pas de race, Race.prix sera NULL, mais pas Espece.prix, qui sera alors sélectionné.

*/

SELECT sexe,COUNT(sexe),GROUP_CONCAT(nom)
FROM animal
WHERE espece_id=4
GROUP BY sexe;

SELECT nom_latin,COUNT(animal.id) AS nb
FROM animal INNER JOIN espece ON animal.espece_id=espece.id
WHERE sexe='M'
GROUP BY nom_latin
HAVING nb<5
ORDER BY nom_latin;

SET lc_time_names = 'fr_FR';
SELECT nom, DATE(date_naissance) AS date_naiss, 
        DAY(date_naissance) AS jour, 
        DAYOFMONTH(date_naissance) AS jour, 
        DAYOFWEEK(date_naissance) AS jour_sem,
        WEEKDAY(date_naissance) AS jour_sem2,
        DAYNAME(date_naissance) AS nom_jour, 
        DAYOFYEAR(date_naissance) AS jour_annee,
        MONTH(date_naissance) AS numero_mois, 
        MONTHNAME(date_naissance) AS nom_mois
FROM Animal
WHERE espece_id = 4;

SELECT nom, date_naissance, DATE_FORMAT(date_naissance, '%d/%m/%Y'), DATE_FORMAT(date_naissance, 'le %W %e %M %Y') AS jolie_date
FROM Animal
WHERE espece_id = 4;

SELECT DATE_FORMAT(NOW(), 'Nous sommes aujourd''hui le %d %M de l''année %Y. Il est actuellement %l heures et %i minutes.') AS Top_date_longue;

SELECT DATE_FORMAT(NOW(), '%d %b. %y - %r') AS Top_date_courte;

SELECT DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'EUR')) AS date_eur,
       DATE_FORMAT(NOW(), GET_FORMAT(TIME, 'JIS')) AS heure_jis,
       DATE_FORMAT(NOW(), GET_FORMAT(DATETIME, 'USA')) AS date_heure_usa;

SELECT ADDDATE('2011-05-21', INTERVAL 3 MONTH) AS date_interval,  
-- Avec DATE et INTERVAL
ADDDATE('2011-05-21 12:15:56', INTERVAL '3 02:10:32' DAY_SECOND) AS datetime_interval, 
-- Avec DATETIME et INTERVAL
ADDDATE('2011-05-21', 12) AS date_nombre_jours,                                        
-- Avec DATE et nombre de jours
ADDDATE('2011-05-21 12:15:56', 42) AS datetime_nombre_jours;                           
-- Avec DATETIME et nombre de jours


SELECT nom, date_naissance
FROM animal
WHERE WEEK(date_naissance)<9;

SELECT nom, CONCAT_WS(' ',DAY(date_naissance), MONTHNAME(date_naissance))
FROM animal
WHERE YEAR(date_naissance)<2007;

SELECT date_naissance, DATEDIFF(date_naissance,'2008-02-28')
FROM animal
WHERE nom='Moka';

SELECT date_naissance, ADDDATE(date_naissance,INTERVAL 25 YEAR)
FROM animal
WHERE espece_id=4;

SELECT id, MAX(date_naissance)
FROM animal
WHERE id IN (13,18,20,22);

SELECT MAX(date_naissance),MIN(date_naissance)
FROM animal
WHERE id IN (13,18,20,22);


/*
Historisation

Voici deux exemples de systèmes d'historisation :

l'un très basique, gardant simplement trace de l'insertion (date et utilisateur) et de la dernière modification (date et utilisateur), et se faisant directement dans la table concernée ;
l'autre plus complet, qui garde une copie de chaque version antérieure des lignes dans une table dédiée, ainsi qu'une copie de la dernière version en cas de suppression.
Historisation basique

On va utiliser cette historisation pour la table Race. Libre à vous d'adapter ou de créer les triggers d'autres tables pour les historiser également de cette manière.

On ajoute donc quatre colonnes à la table. Ces colonnes seront toujours remplies automatiquement par les triggers.

-- On modifie la table Race
ALTER TABLE Race 
    ADD COLUMN date_insertion DATETIME, -- date d'insertion
    ADD COLUMN utilisateur_insertion VARCHAR(20), -- utilisateur ayant inséré la ligne
    ADD COLUMN date_modification DATETIME, -- date de dernière modification
    ADD COLUMN utilisateur_modification VARCHAR(20); -- utilisateur ayant fait la dernière modification

-- On remplit les colonnes
UPDATE Race 
SET date_insertion = NOW() - INTERVAL 1 DAY, 
    utilisateur_insertion = 'Test', 
    date_modification = NOW()- INTERVAL 1 DAY, 
    utilisateur_modification = 'Test';
J'ai mis artificiellement les dates d'insertion et de dernière modification à la veille d'aujourd'hui, et les utilisateurs pour l'insertion et la modification à "Test", afin d'avoir des données intéressantes lors des tests. Idéalement, ce type d'historisation doit bien sûr être mis en place dès la création de la table.

Occupons-nous maintenant des triggers. Il en faut sur l'insertion et sur la modification.

DELIMITER |
CREATE TRIGGER before_insert_race BEFORE INSERT
ON Race FOR EACH ROW
BEGIN
    SET NEW.date_insertion = NOW();
    SET NEW.utilisateur_insertion = CURRENT_USER();
    SET NEW.date_modification = NOW();
    SET NEW.utilisateur_modification = CURRENT_USER();
END |

CREATE TRIGGER before_update_race BEFORE UPDATE
ON Race FOR EACH ROW
BEGIN
    SET NEW.date_modification = NOW();
    SET NEW.utilisateur_modification = CURRENT_USER();
END |
DELIMITER ;
Les triggers sont très simples : ils mettent simplement à jour les colonnes d'historisation nécessaires ; ils doivent donc nécessairement être BEFORE.

*/



select * from article \G
-- \G permet d'afficher le résultat de façon verticale. Idéal quand il y a bcp de texte !!!


--MAJ une nouvelle colonne en comptant des id
UPDATE article SET nbCommentaires=(SELECT COUNT(*) FROM commentaire WHERE commentaire.article_id = article.id);
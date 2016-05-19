/* Création de la BDD */

DROP DATABASE IF EXISTS blog_olivia;

CREATE DATABASE blog_olivia CHARACTER SET 'utf8';
USE blog_olivia;

/* Création des tables */

CREATE TABLE Categorie (
	id INT UNSIGNED AUTO_INCREMENT,
	nom VARCHAR(150) NOT NULL,
	description VARCHAR(300),
	PRIMARY KEY(id)
);

CREATE TABLE Categorie_article (
	id_categorie INT UNSIGNED,
	id_article INT UNSIGNED,
	PRIMARY KEY (id_categorie, id_article)
);

CREATE TABLE Article (
	id INT UNSIGNED AUTO_INCREMENT,
	titre VARCHAR(100) NOT NULL,
	texte VARCHAR(300),
	resume VARCHAR(150),
	date_heure_publication DATETIME,
	id_auteur INT UNSIGNED,
	PRIMARY KEY(id)
);

CREATE TABLE Utilisateur(
	id INT UNSIGNED AUTO_INCREMENT,
	pseudo VARCHAR(30) NOT NULL UNIQUE,
	email VARCHAR(50) NOT NULL UNIQUE,
	password VARCHAR(20) NOT NULL,
	PRIMARY KEY(id) 
);

CREATE TABLE Commentaire(
	id INT UNSIGNED AUTO_INCREMENT,
	texte VARCHAR(500),
	date_heure_publication DATETIME,
	id_article INT UNSIGNED NOT NULL,
	id_utilisateur INT UNSIGNED,	/*Un utilisateur n'est pas forcément lié à un commentaire */
	PRIMARY KEY(id)
);

/* Création des jointures */

ALTER TABLE Article ADD FOREIGN KEY (id_auteur) REFERENCES Utilisateur(id);

ALTER TABLE Commentaire ADD FOREIGN KEY (id_article) REFERENCES Article(id);

ALTER TABLE Categorie_article ADD FOREIGN KEY (id_categorie) REFERENCES Categorie(id);

ALTER TABLE Categorie_article ADD FOREIGN KEY (id_article) REFERENCES Article(id);


/* Création de données dans la table utilisateur */

INSERT INTO Utilisateur VALUES(NULL, 'odc', 'odc@email.com', 'odc');
INSERT INTO Utilisateur VALUES(NULL, 'toto', 'toto@email.com', 'toto');

/* Création de données dans la table article */

INSERT INTO Article VALUES (NULL, 'titre1', 'ceci est mon article 1', NULL, '2016-03-01 12:00:01', 1);
INSERT INTO Article VALUES (NULL, 'titre2', 'ceci est mon second article', NULL, '2016-04-02 12:00:01', 1);
INSERT INTO Article VALUES (NULL, 'titre3', 'ceci est mon troisieme article', 'il date de 2014', '2014-04-02 12:00:01', 1);
INSERT INTO Article VALUES (NULL, 'titre de toto', 'ceci est un article', NULL, '2014-04-02 12:00:01', 2);

/* Création de données dans la table categorie */

INSERT INTO Categorie VALUES (NULL, 'Soleil', 'ecrire ici des sujets lumineux !');
INSERT INTO Categorie VALUES (NULL, 'Pluie', 'ecrire ici des sujets tristes');

/* Création de données dans la table categorie_article */

INSERT INTO Categorie_article VALUES (1,1);
INSERT INTO Categorie_article VALUES (1,2);
INSERT INTO Categorie_article VALUES (1,4);
INSERT INTO Categorie_article VALUES (2,3);

/* Création de données dans la table commentaire */

INSERT INTO Commentaire VALUES (NULL, 'Il est trop bien ton article', '2016-02-14 12:32:00', 1, 1);
INSERT INTO Commentaire VALUES (NULL, 'Nan je le trouve null', '2016-02-15 12:32:00', 1, 2);
INSERT INTO Commentaire VALUES (NULL, 'NON ! Il est trop bien ton article', '2016-02-16 12:32:00', 1, 1);
INSERT INTO Commentaire VALUES (NULL, 'Bon OK si tu insistes', '2016-02-17 12:32:00', 1, 2);
INSERT INTO Commentaire VALUES (NULL, 'Coucou', '2016-02-15 12:32:00', 2, NULL);
INSERT INTO Commentaire VALUES (NULL, 'Coucou', '2016-02-15 12:32:00', 2, NULL);
INSERT INTO Commentaire VALUES (NULL, 'Coucou', '2016-02-15 12:32:00', 3, NULL);

/* Requete Page d'accueil */

SELECT a.titre, a.date_heure_publication, u.pseudo AS Auteur, a.resume
FROM Article AS a
INNER JOIN Utilisateur As u
WHERE a.id_auteur=u.id
ORDER BY a.date_heure_publication DESC;

/* Requete Page utilisateur */

SELECT a.titre, a.texte
FROM Article AS a
WHERE a.id_auteur=1
ORDER BY a.date_heure_publication DESC;

/* Requete Page catégorie */

SELECT a.titre, a.date_heure_publication, u.pseudo AS Auteur, a.resume
FROM Article AS a
INNER JOIN Utilisateur As u
WHERE a.id_auteur=u.id AND a.id IN (SELECT id_article from Categorie_article Where id_categorie=1)
ORDER BY a.date_heure_publication DESC;

/* Requete Page Article */

SELECT a.*, u.pseudo AS Auteur
FROM Article AS a
INNER JOIN Utilisateur As u
WHERE a.id_auteur=u.id AND a.id=1;


SELECT c.texte, c.date_heure_publication, u.pseudo As Commentateur
FROM Commentaire AS c
INNER JOIN Utilisateur As u
WHERE c.id_utilisateur=u.id AND c.id_article=1
ORDER BY c.date_heure_publication ASC;

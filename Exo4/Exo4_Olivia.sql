
/* Exercice 4 - Olivia */

-- Dans les requettes, je choisi de supprimer les sauts de ligne des résumés, pour améliorer l'affichage des résultats
-- REPLACE(resume,'\r\n',' - ')


-- Page Accueil

SELECT 	titre, 
		COUNT(commentaire.id) AS Nb_commentaires, 
		DATE_FORMAT(date_publication,'%d/%m/%Y') AS Date_de_publication,
		pseudo AS Auteur, 
		REPLACE(resume,'\r\n',' - ') AS Resume
FROM article 
LEFT JOIN commentaire ON article.id = commentaire.article_id 
LEFT JOIN utilisateur ON utilisateur.id = article.auteur_id
GROUP BY titre
ORDER BY date_publication DESC;

-- Page Auteur (id de l’auteur = 2)

SELECT 	titre, 
		DATE_FORMAT(date_publication,'%d %M \'%y') AS Date_de_publication, 
		pseudo AS Auteur, 
		REPLACE(resume,'\r\n',' - ') AS Resume
FROM article
LEFT JOIN utilisateur ON utilisateur.id = article.auteur_id
WHERE auteur_id=2
ORDER BY date_publication DESC;

-- Page Catégorie (id de la catégorie = 3)

SELECT 	a.titre, 
		DATE_FORMAT(a.date_publication, '%d/%m/%Y - %h:%i') AS Date_de_publication, 
		utilisateur.pseudo AS Auteur, 
		REPLACE(a.resume,'\r\n',' - ') AS Resume
FROM article AS a
LEFT JOIN categorie_article ON a.id = categorie_article.article_id
LEFT JOIN categorie ON categorie.id = categorie_article.categorie_id
LEFT JOIN utilisateur ON utilisateur.id = a.auteur_id
WHERE categorie_article.categorie_id = 3
ORDER BY a.date_publication DESC;

-- Page article (id de l'article = 4)

		-- L'article
SELECT 	titre, 
		DATE_FORMAT(date_publication,'%d %M %Y à %h heures %i') AS Date_de_publication, 
		contenu, 
		GROUP_CONCAT(categorie.nom) AS Categories,
		pseudo AS Auteur
FROM article
LEFT JOIN categorie_article ON article.id = categorie_article.article_id
LEFT JOIN categorie ON categorie.id = categorie_article.categorie_id
LEFT JOIN utilisateur ON utilisateur.id = article.auteur_id
WHERE article.id = 4;


		-- Les commentaires
SELECT Commentaire.contenu AS Commentaire,
       DATE_FORMAT(Commentaire.date_commentaire, '%d/%m/%Y') AS date_commentaire, 
       Utilisateur.pseudo AS Auteur
FROM Commentaire
LEFT JOIN Utilisateur ON Commentaire.auteur_id = Utilisateur.id
WHERE Commentaire.article_id = 4
ORDER BY Commentaire.date_commentaire;

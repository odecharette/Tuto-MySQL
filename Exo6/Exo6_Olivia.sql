/**************************
1. Sur la page d’accueil, on affiche le nombre de commentaires de chaque article. On veut éviter de calculer cela à chaque affichage de la page. 
Il faut donc stocker ce nombre quelque part, et automatiser sa mise à jour afin que l’information soit toujours exacte.
***************************/


-- Création d'une colonne nb_commentaires dans la table article
ALTER TABLE article ADD nb_commentaires INT UNSIGNED;

-- Initialisation de la colonne nb_commentaires pour chaque article existant;

DELIMITER |
DROP PROCEDURE IF EXISTS init_nombre |
CREATE PROCEDURE init_nombre ()
BEGIN

	DECLARE cpt INT DEFAULT 0;

	DECLARE nb_lignes INT DEFAULT 0;
	SELECT COUNT(id) into nb_lignes FROM article;

	WHILE cpt <= nb_lignes DO
		UPDATE article
		SET nb_commentaires = (SELECT COUNT(id) FROM commentaire WHERE commentaire.article_id=cpt)
		WHERE article.id = cpt;

		SET cpt = cpt+1;
	END WHILE;	

END |
DELIMITER ;

CALL init_nombre();


-- Création de 2 triggers pour maintenir ce nombre à jour :

-- Le trigger doit incrémenter nb_commentaires lorsqu'un commentaire est crée

DELIMITER |
DROP TRIGGER IF EXISTS inc_nb_commentaires |
CREATE TRIGGER inc_nb_commentaires AFTER INSERT ON commentaire FOR EACH ROW
BEGIN
	 UPDATE article
	 SET nb_commentaires = nb_commentaires + 1
	 WHERE article.id = NEW.article_id;
END |

 -- Le trigger doit décrémenter nb_commentaires lorsqu'un commentaire est supprimé

DROP TRIGGER IF EXISTS dec_nb_commentaires |
CREATE TRIGGER dec_nb_commentaires AFTER DELETE ON commentaire FOR EACH ROW
BEGIN
	 UPDATE article
	 SET nb_commentaires = nb_commentaires - 1
	 WHERE article.id = OLD.article_id;
END |

DELIMITER ;

-- Requete d'affichage du nombre de commentaires par article

SELECT id, titre, nb_commentaires FROM article;



/**************************
2. Chaque article doit contenir un résumé (ou extrait), qui sera affiché sur la page d’accueil. Mais certains auteurs oublient parfois d’en écrire un. 
Il faut donc s’arranger pour créer automatiquement un résumé en prenant les 150 premiers caractères de l’article, si l’auteur n’en a pas écrit.
***************************/

-- Création d'un trigger pour remplir le résumé s'il n'existe pas
DELIMITER |
DROP TRIGGER IF EXISTS ajoute_resume |
CREATE TRIGGER ajoute_resume BEFORE INSERT ON article FOR EACH ROW
BEGIN
	IF NEW.resume IS NULL THEN
		SET NEW.resume = LEFT(NEW.contenu,150);
	END IF;

END |
DELIMITER ;


/**************************
3. Enfin, les administrateurs du site veulent connaître quelques statistiques sur les utilisateurs enregistrés : 
le nombre d’articles écrits, la date du dernier article, le nombre de commentaires écrits et la date du dernier commentaire. 
Ces informations doivent être stockées pour ne pas devoir les recalculer chaque fois. 
Par contre, elles ne doivent pas nécessairement être à jour à tout moment. On doit disposer d’un outil pour faire les mises à jour à la demande.
***************************/


-- Création d'une vue matérialisée, pour la gestion des stats
DROP TABLE IF EXISTS vm_stat;
CREATE TABLE vm_stat
ENGINE = InnoDB
	SELECT 	COUNT(distinct article.id) AS nb_article_ecrit,
			MAX(date_publication) AS date_dernier_article,
			COUNT(commentaire.id) AS nb_commentaire_ecrit,
			MAX(date_commentaire) AS date_dernier_commentaire
	FROM article
	LEFT JOIN commentaire ON article.id = commentaire.article_id;

SELECT * FROM vm_stat;

-- création d'une procédure stockée, pour MAJ la vue, à la demande

DELIMITER |
DROP PROCEDURE IF EXISTS maj_vm_stat |
CREATE PROCEDURE maj_vm_stat()
BEGIN
    TRUNCATE vm_stat;

    INSERT INTO vm_stat
    SELECT 	COUNT(distinct article.id) AS nb_article_ecrit,
			MAX(date_publication) AS date_dernier_article,
			COUNT(commentaire.id) AS nb_commentaire_ecrit,
			MAX(date_commentaire) AS date_dernier_commentaire
	FROM article
	LEFT JOIN commentaire ON article.id = commentaire.article_id;
END |
DELIMITER ;

CALL maj_vm_stat();

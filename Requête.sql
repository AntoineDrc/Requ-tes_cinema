a. Informations d’un film (id_film) : titre, année, durée (au format HH:MM) et 
réalisateur 
SELECT film.id_film, film.titre, film.anneeSortie, personne.prenom AS prenom_realisateur, personne.nom AS nom_realisateur,
-- Concaténation et formatage de la durée du film de minutes en heures et minutes
CONCAT (FLOOR(film.duree / 60), 'h', -- Division de la durée par 60 pour obtenir les heures, arrondies à l'entier inférieur avec FLOOR
		LPAD (film.duree % 60, 2, '0'), 'm') -- Modulo pour obtenir les minutes restantes et utilisation de LPAD pour assurer deux chiffres
		AS duree
FROM film
-- Ici, on utilise l'identifiant du réalisateur stocké dans la table film pour trouver la ligne correspondante dans la table realisateur
--La condition de jointure assure que l'on ne prend que les réalisateurs qui ont été assignés à chaque film spécifique
JOIN realisateur ON film.id_realisateur = realisateur.id_realisateur
JOIN personne ON realisateur.id_personne = personne.id_personne 
-- Après avoir identifié le bon réalisateur, on utilise son identifiant de personne pour trouver ses informations personnelles
-- dans la table personne. Cela permet d'obtenir le prénom et le nom réels du réalisateur pour chaque film.


b. Liste des films dont la durée excède 2h15 classés par durée (du + long au + court)
SELECT film.titre,
CONCAT (FLOOR(film.duree / 60), 'h', LPAD (film.duree % 60, 2, '0'), 'm') AS duree
FROM film
WHERE film.duree > 135
ORDER BY film.duree;


c. Liste des films d’un réalisateur (en précisant l’année de sortie) 
SELECT film.titre, film.anneeSortie, personne.prenom AS prenomRealisateur, personne.nom AS prenomRealisateur
FROM film
JOIN realisateur ON film.id_realisateur = realisateur.id_realisateur
JOIN personne ON realisateur.id_personne = personne.id_personne


d. Nombre de films par genre (classés dans l’ordre décroissant)
SELECT categorie.genre,
COUNT(film.id_film) AS nbFilms
FROM categorie 
JOIN appartenir ON categorie.id_categorie = appartenir.id_categorie
JOIN film ON appartenir.id_film = film.id_film
GROUP BY categorie.genre
ORDER BY categorie.genre DESC  


e. Nombre de films par réalisateur (classés dans l’ordre décroissant)
SELECT personne.prenom AS prenomRealisateur, personne.nom AS nomRealisateur,
COUNT(film.id_film) AS nbFilms
FROM film
JOIN realisateur ON film.id_realisateur = realisateur.id_realisateur
JOIN personne ON realisateur.id_personne = personne.id_personne
GROUP BY realisateur.id_realisateur
ORDER BY realisateur.id_realisateur DESC 


f. Casting d’un film en particulier (id_film) : nom, prénom des acteurs + sexe
SELECT film.id_film, film.titre, 
-- la fonction GROUP_CONCAT concatène les résultats et CONCAT pour fusionner les prénom, nom et sexe avec du texte explicatif
GROUP_CONCAT(CONCAT(personne.prenom, ' ', personne.nom, ', sexe : ', personne.sexe) SEPARATOR ' / ') AS acteurs
FROM film 
JOIN jouer ON film.id_film = jouer.id_film
JOIN acteur ON jouer.id_acteur = acteur.id_acteur
JOIN personne ON acteur.id_personne = personne.id_personne
GROUP BY film.id_film;


g. Films tournés par un acteur en particulier (id_acteur) avec leur rôle et l’année de 
sortie (du film le plus récent au plus ancien)
SELECT film.titre, film.anneeSortie, acteur.id_acteur, personne.prenom AS prenomActeur, personne.nom AS nomActeur, role.nomPersonnage AS role
FROM film 
JOIN jouer ON film.id_film = jouer.id_film 
JOIN role ON jouer.id_role = role.id_role 
JOIN acteur ON jouer.id_acteur = acteur.id_acteur 
JOIN personne ON acteur.id_personne = personne.id_personne
WHERE acteur.id_acteur = 1
ORDER BY film.anneeSortie DESC 


h. Liste des personnes qui sont à la fois acteurs et réalisateurs
SELECT personne.nom, personne.prenom
FROM personne
JOIN acteur ON personne.id_personne = acteur.id_personne
JOIN realisateur ON personne.id_personne = realisateur.id_personne
WHERE acteur.id_personne = realisateur.id_personne 


i. Liste des films qui ont moins de 5 ans (classés du plus récent au plus ancien)
SELECT *
FROM film 
-- DATE_SUB soustrait une période de temps à une date spécifique.
WHERE film.anneeSortie >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR) -- CURDATE() pour obtient la date actuelle / INTERVAL "5 YEAR" : l'intervalle de temps à soustraire
ORDER BY film.anneeSortie DESC 


j. Nombre d’hommes et de femmes parmi les acteurs
SELECT 
-- CASE (dans le cas ou) vérifie si le sexe est 'm'. Si oui, THEN (alors) compte 1, ELSE (sinon) compte 0
SUM(CASE WHEN sexe = 'm' THEN 1 ELSE 0 END) AS nbHommesActeur, -- SUM additionne ensuite tous ces 1 pour donner le nombre total d'hommes acteurs
SUM(CASE WHEN sexe = 'f' THEN 1 ELSE 0 END) AS nbFemmes
FROM personne 
JOIN acteur ON personne.id_personne = acteur.id_personne 
WHERE acteur.id_acteur

k. Liste des acteurs ayant plus de 50 ans (âge révolu et non révolu)
SELECT personne.*,
-- TIMESTAMPDIFF calcul la différence entre deux dates en prenant 3 arguments : Unité (year, month etc), date de début, date de fin, 
TIMESTAMPDIFF(YEAR, personne.dateNaissance, CURDATE()) AS age -- On utilise la fonction une première fois dans le select car on a beson de créér une nouvelle colonne "age"
FROM personne
JOIN acteur ON personne.id_personne = acteur.id_personne
WHERE TIMESTAMPDIFF(YEAR, personne.dateNaissance, CURDATE()) >= 50 -- Puis une deuxième fois dans le where pour filter les personnes au dela de 50 "ans"
AND acteur.id_acteur 


l. Acteurs ayant joué dans 3 films ou plus
SELECT personne.prenom, personne.nom,
COUNT(id_film) AS nbFilms
FROM personne 
JOIN acteur ON personne.id_personne = acteur.id_personne 
JOIN jouer ON acteur.id_acteur = jouer.id_acteur
GROUP BY personne.id_personne
HAVING COUNT(jouer.id_film) > 3

-- Pourquoi utiliser HAVING plutôt que WHERE ?
-- 1. La clause WHERE s'applique avant l'agrégation des données. Elle est utilisée pour filtrer les lignes individuelles 
--    avant que les opérations de GROUP BY ne soient effectuées. Par exemple, WHERE serait utilisé pour filtrer les acteurs 
--    d'un certain pays ou ceux ayant une date de naissance après une certaine année.
--
-- 2. La clause HAVING s'applique après l'agrégation des données. Elle est donc utilisée pour filtrer les résultats basés sur 
--    les conditions qui impliquent des fonctions d'agrégation, comme COUNT, SUM, AVG, etc. Dans ce cas, HAVING est utilisée 
--    pour filtrer les acteurs basés sur le nombre total de films dans lesquels ils ont joué, une information qui n'est 
--    disponible qu'après l'agrégation des données par acteur.
--
-- En résumé, HAVING est nécessaire ici parce que nous filtrons les acteurs sur une condition qui dépend du résultat d'une 
-- fonction d'agrégation (le décompte des films), ce qui n'est pas possible avec la clause WHERE.
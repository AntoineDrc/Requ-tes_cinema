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

g. Films tournés par un acteur en particulier (id_acteur) avec leur rôle et l’année de 
sortie (du film le plus récent au plus ancien)

h. Liste des personnes qui sont à la fois acteurs et réalisateurs

i. Liste des films qui ont moins de 5 ans (classés du plus récent au plus ancien)

j. Nombre d’hommes et de femmes parmi les acteurs

k. Liste des acteurs ayant plus de 50 ans (âge révolu et non révolu)

l. Acteurs ayant joué dans 3 films ou plus
/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01-Cinema-CreerEnv.sql      Auteur : Ch. Stettler
Objet  : Cr�ation et remplissage des tables du cas Cinema
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';  -- d�fini le format des dates

-- suppression des tables
DROP TABLE cin_estGenre;
DROP TABLE cin_film;
DROP TABLE cin_genre;
DROP TABLE cin_type;

-- cr�ation des tables de base
CREATE TABLE cin_type (
   typ_no      NUMBER(5)    CONSTRAINT pk_cin_type PRIMARY KEY,
   typ_nom     VARCHAR2(25) CONSTRAINT nn_typ_nom NOT NULL CONSTRAINT uk_typ_nom UNIQUE
);

CREATE TABLE cin_genre (
   gen_no      NUMBER(5)    CONSTRAINT pk_cin_genre PRIMARY KEY,
   gen_nom     VARCHAR2(25) CONSTRAINT nn_gen_nom NOT NULL CONSTRAINT uk_gen_nom UNIQUE
);

CREATE TABLE cin_film (
   fil_no      NUMBER(5)    CONSTRAINT pk_cin_film PRIMARY KEY,
   fil_titre   VARCHAR2(50) CONSTRAINT nn_fil_nom NOT NULL,
   fil_annee   NUMBER(4),
   fil_duree   VARCHAR2(10),
   fil_sortie  DATE,
   fil_typ_no  NUMBER(5)    CONSTRAINT fk_cin_type_film REFERENCES cin_type (typ_no),
   fil_realis  VARCHAR2(50),
   fil_descr   VARCHAR2(500)
);

CREATE TABLE cin_estGenre (
   est_fil_no  NUMBER(5)    CONSTRAINT fk_cin_estGenre_film  REFERENCES cin_film (fil_no),
   est_gen_no  NUMBER(5)    CONSTRAINT fk_cin_estGenre_genre REFERENCES cin_genre (gen_no),
   CONSTRAINT pk_cin_estGenre PRIMARY KEY (est_fil_no, est_gen_no)
);

-- insertion des donn�es initiales
INSERT INTO cin_type VALUES (1, 'Film');
INSERT INTO cin_type VALUES (2, 'Documentaire');
INSERT INTO cin_type VALUES (3, 'Long-m�trage d''animation');

INSERT INTO cin_genre VALUES (1, 'Action');
INSERT INTO cin_genre VALUES (2, 'Animation');
INSERT INTO cin_genre VALUES (3, 'Art');
INSERT INTO cin_genre VALUES (4, 'Aventure');
INSERT INTO cin_genre VALUES (5, 'Barbare');
INSERT INTO cin_genre VALUES (6, 'Biopic');
INSERT INTO cin_genre VALUES (7, 'Catastrophe');
INSERT INTO cin_genre VALUES (8, 'Cin�ma');
INSERT INTO cin_genre VALUES (9, 'Com�die');
INSERT INTO cin_genre VALUES (10, 'Com�die dramatique');
INSERT INTO cin_genre VALUES (11, 'Com�die romantique');
INSERT INTO cin_genre VALUES (12, 'Drame');
INSERT INTO cin_genre VALUES (13, 'Ecologie');
INSERT INTO cin_genre VALUES (14, 'Epouvante-Horreur');
INSERT INTO cin_genre VALUES (15, 'Exp�rimental');
INSERT INTO cin_genre VALUES (16, 'Fantastique');
INSERT INTO cin_genre VALUES (17, 'Guerre');
INSERT INTO cin_genre VALUES (18, 'Historique');
INSERT INTO cin_genre VALUES (19, 'Jeunesse');
INSERT INTO cin_genre VALUES (20, 'Musique');
INSERT INTO cin_genre VALUES (21, 'Nature');
INSERT INTO cin_genre VALUES (22, 'Photographie');
INSERT INTO cin_genre VALUES (23, 'Policier');
INSERT INTO cin_genre VALUES (24, 'Politique');
INSERT INTO cin_genre VALUES (25, 'Portrait');
INSERT INTO cin_genre VALUES (26, 'Romance');
INSERT INTO cin_genre VALUES (27, 'Science');
INSERT INTO cin_genre VALUES (28, 'Science-fiction');
INSERT INTO cin_genre VALUES (29, 'Simpliste');
INSERT INTO cin_genre VALUES (30, 'Soci�t�');
INSERT INTO cin_genre VALUES (31, 'Sport');
INSERT INTO cin_genre VALUES (32, 'Thriller');
COMMIT;

INSERT INTO cin_film VALUES (1, 'The Pale Blue Eye', 2022, '2 h 08', '06/01/2023', 1, 'Scott Cooper', '1830. Un d�tective chevronn� enqu�te sur les meurtres qui ont eu lieu au sein de l''Acad�mie militaire am�ricaine de West Point, aid� par une jeune recrue m�ticuleuse qui deviendra plus tard un auteur mondialement connu, Edgar Allan Poe');
INSERT INTO cin_film VALUES (2, 'Babylon', 2022, '3 h 09', '18/01/2023', 1, 'Damien Chazelle', 'Los Angeles des ann�es 1920. R�cit d''une ambition d�mesur�e et d''exc�s les plus fous, l''ascension et la chute de diff�rents personnages lors de la cr�ation d''Hollywood, une �re de d�cadence et de d�pravation sans limites.');
INSERT INTO cin_film VALUES (3, 'T�R', 2022, '2 h 38', '25/01/2023', 1, 'Todd Field', 'Lydia T�r, cheffe avant-gardiste d''un grand orchestre symphonique allemand, est au sommet de son art et de sa carri�re. Le lancement de son livre approche et elle pr�pare un concert tr�s attendu de la c�l�bre Symphonie n� 5 de Gustav Mahler. Mais, en l''espace de quelques semaines, sa vie va se d�sagr�ger d''une fa�on singuli�rement actuelle');
INSERT INTO cin_film VALUES (4, 'La Montagne', 2022, '1 h 52', '01/02/2023', 1, 'Thomas Salvador', 'Pierre, ing�nieur parisien, se rend dans les Alpes pour son travail. Irr�sistiblement attir� par les montagnes, il s''installe un bivouac en altitude et d�cide de ne plus redescendre. L�-haut, il fait la rencontre de L�a et d�couvre de myst�rieuses lueurs');
INSERT INTO cin_film VALUES (5, 'La Femme de Tcha�kovski', 2022, '2 h 23', '15/02/2023', 1, 'Kirill Serebrennikov', 'Russie, 19�me si�cle. Antonina Miliukova, jeune femme ais�e et brillante, �pouse le compositeur Piotr Tcha�kovski. Mais l''amour qu''elle lui porte tourne � l''obsession et la jeune femme est violemment rejet�e. Consum�e par ses sentiments, Antonina accepte de tout endurer pour rester aupr�s de lui');
INSERT INTO cin_film VALUES (6, 'The Fabelmans', 2022, '2 h 31', '22/02/2023', 1, 'Steven Spielberg', 'Le jeune Sammy Fabelman tombe amoureux du cin�ma apr�s que ses parents l''ont emmen� voir "The Greatest Show on Earth". Arm� d''une cam�ra, Sammy commence � faire ses propres films � la maison, pour le plus grand plaisir de sa m�re qui le soutient.');
INSERT INTO cin_film VALUES (7, 'Creed III', 2023, '1 h 56', '01/03/2023', 1, 'Michael B. Jordan', 'Idole de la boxe et entour� de sa famille, Adonis Creed n''a plus rien � prouver. Jusqu''au jour o� son ami d''enfance, Damian, prodige de la boxe lui aussi, refait surface. A peine sorti de prison, Damian est pr�t � tout pour monter sur le ring et reprendre ses droits');
INSERT INTO cin_film VALUES (8, 'The Whale', 2022, '1 h 57', '08/03/2023', 1, 'Darren Aronofsky', 'Charlie, professeur d''anglais reclus chez lui, tente de renouer avec sa fille adolescente pour une ultime chance de r�demption');
INSERT INTO cin_film VALUES (9, 'Tetris', 2023, '1 h 58', '31/03/2023', 1, 'Jon S. Baird', 'Tir� de la vraie histoire du d�veloppeur et promoteur de jeux vid�o Henk Rogers et de sa rencontre avec Tetris en 1988. Lorsqu''il entreprend de faire conna�tre ce jeu au monde entier, il plonge dans une dangereuse spirale de mensonges et de corruption derri�re le rideau de fer sovi�tique');
INSERT INTO cin_film VALUES (10, 'Super Mario Bros, le film', 2023, '1 h 32', '05/04/2023', 3, 'Aaron Horvath et Michael Jelenic', 'Alors qu''ils tentent de r�parer une canalisation souterraine, Mario et son fr�re Luigi, tous deux plombiers, se retrouvent plong�s dans un nouvel univers f�erique � travers un myst�rieux conduit. Mais lorsque les deux fr�res sont s�par�s, Mario s''engage dans une aventure tr�pidante pour retrouver son fr�re');
INSERT INTO cin_film VALUES (11, 'Les Trois Mousquetaires - D''Artagnan', 2023, '2 h 01', '05/04/2023', 1, 'Martin Bourboulon', 'Beau tente d�sesp�r�ment de rejoindre sa m�re. Mais l''univers semble se liguer contre lui');
INSERT INTO cin_film VALUES (12, 'Les Gardiens de la galaxie Vol. 3', 2023, '2 h 30', '03/05/2023', 1, 'James Gunn', 'Notre bande de marginaux favorite a quelque peu chang�. Peter Quill, qui pleure toujours la perte de Gamora, doit rassembler son �quipe pour d�fendre l''univers et prot�ger l''un des siens. En cas d''�chec, cette mission pourrait bien marquer la fin des Gardiens tels que nous les connaissons.');
INSERT INTO cin_film VALUES (13, 'Spider-Man: Across the Spider-Verse', 2023, '2 h 20', '31/05/2023', 3, 'Joaquim Dos Santos, Kemp Powers et Justin Thompson', 'Apr�s avoir retrouv� Gwen Stacy, Spider-Man, le sympathique h�ros originaire de Brooklyn, est catapult� � travers le Multivers, o� il rencontre une �quipe de Spider-H�ros charg�e d''en prot�ger l''existence. Mais lorsque les h�ros s''opposent sur la fa�on de g�rer une nouvelle menace, Miles se retrouve confront� � eux et doit red�finir ce que signifie �tre un h�ros afin de sauver les personnes qu''il aime le plus.');
INSERT INTO cin_film VALUES (14, '�l�mentaire', 2023, '1 h 42', '21/06/2023', 3, 'Peter Sohn', 'Dans la ville d''Element City, le feu, l''eau, la terre et l''air vivent dans la plus parfaite harmonie. C''est ici que r�sident Flam, une jeune femme intr�pide et vive d''esprit, au caract�re bien tremp�, et Flack, un gar�on sentimental et amusant, plut�t suiveur dans l''�me. L''amiti� qu''ils se portent remet en question les croyances de Flam sur le monde dans lequel ils vivent');
INSERT INTO cin_film VALUES (15, 'The Covenant', 2023, '2 h 03', '23/06/2023', 1, 'Guy Ritchie', 'Lors de sa derni�re mission en Afghanistan, le sergent John Kinley fait �quipe avec l''interpr�te Ahmed pour arpenter la r�gion. Lorsque leur unit� tombe dans une embuscade au cours d''une patrouille, Kinley et Ahmed sont les seuls survivants. Alors que des combattants ennemis les poursuivent, Ahmed risque sa vie pour transporter Kinley, bless�, en s�curit�. De retour sur le sol am�ricain, Kinley apprend qu''Ahmed et sa famille n''ont pas obtenu la possibilit� d''entrer aux Etats-Unis');
INSERT INTO cin_film VALUES (16, 'Indiana Jones et le cadran de la destin�e', 2023, '2 h 34', '28/06/2023', 1, 'James Mangold', 'En 1969, l''arch�ologue et aventurier am�rican Indiana Jones est oppos� � la course � l''espace en raison du fait que les �tats-Unis ont recrut� d''anciens nazis pour battre l''Union Sovi�tique dans cette comp�tition. Sa filleule Helena l''accompagne dans ce combat. Pendant ce temps, J�rgen Voller, un employ� de la NASA et ex-nazi impliqu� dans le programme lunaire cherche � rendre le monde meilleur � son id�e');
INSERT INTO cin_film VALUES (17, 'Mission: Impossible - Dead Reckoning Partie 1', 2023, '2 h 43', '12/07/2023', 1, 'Christopher McQuarrie', 'Le contr�le du futur et le destin du monde sont en jeu. Alors que les forces obscures de son pass� ressurgissent, Ethan s''engage dans une course mortelle autour du globe. Confront� � un puissant et �nigmatique ennemi, Ethan r�alise que rien ne peut se placer au-dessus de sa mission - pas m�me la vie de ceux qu''il aime');
INSERT INTO cin_film VALUES (18, 'Oppenheimer', 2023, '3 h', '19/07/2023', 1, 'Christopher Nolan', 'En 1942, convaincus que l''Allemagne nazie est en train de d�velopper une arme nucl�aire, les �tats-Unis initient, dans le plus grand secret, le "Projet Manhattan" destin� � mettre au point la premi�re bombe atomique de l''histoire. Pour piloter ce dispositif, le gouvernement engage J. Robert Oppenheimer, brillant physicien, qui sera bient�t surnomm� "le p�re de la bombe atomique". C''est dans le laboratoire ultra-secret de Los Alamos, au c�ur du d�sert du Nouveau-Mexique, ...');
INSERT INTO cin_film VALUES (19, 'Barbie', 2023, '1 h 54', '19/07/2023', 1, 'Greta Gerwig', '� Barbie Land, vous �tes un �tre parfait dans un monde parfait. Sauf si vous �tes en crise existentielle, ou si vous �tes Ken');
INSERT INTO cin_film VALUES (20, 'Un jour et demi', 2023, '1 h 30', '01/09/2023', 1, 'Fares Fares', 'Pour retrouver sa fille, Artan prend son ex-femme Louise en otage et l''embarque, elle et le n�gociateur de crise Lukas, dans un road trip intense et riche en �motions. Ensemble, ils traversent la campagne su�doise au coeur de l''�t�, avec la police � leurs trousses.');
INSERT INTO cin_film VALUES (21, 'Live stream', 2023, '1 h 30', '01/09/2023', 1, '', 'Un producteur de t�l�vision ind�pendant re�oit un lien vers une cam�ra espion de sa propre petite amie.Il d�cide de prendre les choses en main et de la sauver, mais sombre dans le monde miteux des �missions ill�gales.');
INSERT INTO cin_film VALUES (22, 'Kandahar', 2023, '1 h 59', '01/09/2023', 1, 'Ric Roman Waugh', 'Tom Harris est un agent secret de la CIA travaillant au Moyen-Orient. Une fuite des renseignements r�v�le son identit�. Coinc�s au c�ur d''un territoire hostile, Harris et son traducteur doivent se frayer un chemin hors du d�sert jusqu''� Kandahar, en Afghanistan, tout en �chappant aux forces...');
INSERT INTO cin_film VALUES (23, 'The Adults', 2023, '1 h 31', '04/09/2023', 1, 'Dustin Guy Defa', 'Alors qu''Eric rentre chez lui pour une courte visite, il se retrouve coinc� entre rattraper le temps perdu avec ses s�urs et courir apr�s une victoire avec son ancien groupe de poker.');
INSERT INTO cin_film VALUES (24, 'Transfariana', 2023, NULL, '04/09/2023', 1, 'Joris Lachaise', 'L''histoire d''amour inattendue entre une ancienne travailleuse du sexe trans et un rebelle des FARC commenc�e dans une prison colombienne et qui a d�bouch� sur une alliance entre des militants trans et des militants des FARC qui ont d�pos� les armes.');
INSERT INTO cin_film VALUES (25, 'Le Ciel rouge', 2023, '1 h 42', '06/09/2023', 1, 'Christian Petzold', 'Une petite maison de vacances au bord de la mer Baltique. Les journ�es sont chaudes et il n''a pas plu depuis des semaines. Quatre jeunes gens se r�unissent, des amis anciens et nouveaux. Les for�ts dess�ch�es qui les entourent commencent � s''enflammer, tout comme leurs �motions. Le bonheur, la...');
INSERT INTO cin_film VALUES (26, 'Le Ch�teau solitaire dans le miroir', 2022, '1 h 56', '06/09/2023', 3, 'Keiichi Hara', 'Un beau jour, le miroir dans la chambre de Kokoro se met � scintiller. � peine la jeune fille l''a-t-elle effleur� qu''elle se retrouve dans un formidable ch�teau digne d''un conte de f�es. L�, une myst�rieuse fillette affubl�e d''un masque de loup lui soumet un d�fi. Elle a un an pour l''accomplir et...');
INSERT INTO cin_film VALUES (27, 'Anti-Squat', 2023, '1 h 35', '06/09/2023', 1, 'Nicolas Silhol', 'In�s est menac�e de se faire expulser de chez elle avec Adam, son fils de 14 ans. A la recherche d''un emploi, elle est prise � l''essai chez Anti-Squat, une soci�t� qui loge des personnes dans des bureaux inoccup�s pour les prot�ger contre les squatteurs. Son r�le : recruter les r�sidents et faire...');
INSERT INTO cin_film VALUES (28, 'Visions', 2023, '2 h 03', '06/09/2023', 1, 'Yann Gozlan', 'Pilote de ligne confirm�e, Estelle m�ne, entre deux vols long-courriers, une vie parfaite avec Guillaume, son mari aimant et protecteur. Un jour, par hasard, dans un couloir d''a�roport, elle recroise la route d''Ana, photographe avec qui elle a eu une aventure passionn�e vingt ans plus t�t. Estelle...');
INSERT INTO cin_film VALUES (29, 'Sentinelle', 2023, NULL, '08/09/2023', 1, 'Hugo Benamozig et David Caviglioli', 'Fran�ois Sentinelle m�ne une double vie. Le jour, il est le flic le plus m�diatique de l''�le de la R�union, connu pour ses m�thodes muscl�es et ses chemises � fleur, poursuivant les criminels � bord de son c�l�bre defender jaune. Mais hors des heures de service (et bien souvent pendant), Sentinelle...');
INSERT INTO cin_film VALUES (30, 'Le monde selon mon p�re', 2023, '1 h 55', '13/09/2023', 1, 'Petra Seeger', '� la lumi�re de photos de famille prises par son p�re, une femme se rem�more son adolescence dans l''Allemagne des ann�es 1960.');
INSERT INTO cin_film VALUES (31, 'Un m�tier s�rieux', 2023, '1 h 41', '13/09/2023', 1, 'Thomas Lilti', 'C''est la rentr�e. Une nouvelle ann�e scolaire au coll�ge qui voit se retrouver Pierre, Meriem, Fouad, Sophie, Sandrine, Alix et Sofiane, un groupe d''enseignants engag�s et soud�s. Ils sont rejoints par Benjamin, jeune professeur rempla�ant sans exp�rience et rapidement confront� aux affres du...');
INSERT INTO cin_film VALUES (32, 'L''�t� dernier', 2023, '1 h 44', '13/09/2023', 1, 'Catherine Breillat', 'Anne, avocate renomm�e, vit en harmonie avec son mari Pierre et leurs filles de 6 et 7 ans. Un jour, Th�o, 17 ans, fils de Pierre d''un pr�c�dent mariage, emm�nage chez eux. Peu de temps apr�s, il annonce � son p�re qu''il a une liaison avec Anne. Elle nie.');
INSERT INTO cin_film VALUES (33, 'Le Grand Chariot', 2023, '1 h 35', '13/09/2023', 1, 'Philippe Garrel', 'La destin�e romanesque et tragique d''une fratrie d''artistes marionnettistes.');
INSERT INTO cin_film VALUES (34, 'Loup y es-tu ?', 2021, '1 h 26', '13/09/2023', 2, 'Clara Bouffartigue', 'Souvent adress�s par l''�cole, les enfants et leurs parents arrivent au Centre Claude Bernard avec leur �chec en bandouli�re, sous le manteau ou sous la peau, c''est selon, mais toujours avec cette souffrance dont ils s''accommodent mal. Qu''est-ce que cette fatalit� qui s''abat sur notre famille ? Il...');
INSERT INTO cin_film VALUES (35, 'Noctambule', 2023, '30 min', '16/09/2023', 1, 'Adrien Caulier', 'Une jeune femme d�cide de rentrer chez elle le soir lorsqu''elle ressent un profond malaise lors de la f�te chez une amie. C''est alors qu''une �trange silhouette va commencer � la suivre...');
INSERT INTO cin_film VALUES (36, 'Ma promesse', 2019, '1 h 56', '20/09/2023', 1, 'Martha Coolidge', 'Robert est un chanteur d''op�ra catholique et Rachel, une violoniste juive. Ils r�vent de se produire un jour ensemble au Carnegie Hall. Lorsqu''ils sont s�par�s par l''invasion allemande de la Pologne, Robert jure de retrouver Rachel, quoi qu''il arrive. Sa qu�te l''entra�ne dans un voyage au c�ur de...');
INSERT INTO cin_film VALUES (37, 'Last Dance !', 2022, '1 h 23', '20/09/2023', 1, 'Delphine Lehericey', 'Retrait� contemplatif, Germain se retrouve soudainement veuf � 75 ans. Il n''a m�me pas le temps de souffler que sa famille s''immisce dans son quotidien : visites et appels incessants, repas organis�s � l''avance� Sa vie devient r�gl�e comme une montre suisse ! Mais Germain a l''esprit ailleurs...');
INSERT INTO cin_film VALUES (38, 'D�serts', 2023, '2 h 06', '20/09/2023', 1, 'Faouzi Bensa�di', 'Mehdi et Hamid travaillent pour une agence de recouvrement � Casablanca. Les deux pieds nickel�s arpentent des villages lointains du grand sud marocain pour soutirer de l''argent � des familles surendett�es...');
INSERT INTO cin_film VALUES (39, 'Jeune cin�ma', 2022, '1 h 13', '27/09/2023', 2, 'Yves-Marie Mahe', 'Jeune cin�ma est un documentaire d''archives sur le mythique festival de cin�ma d''Hy�res qui eut lieu entre 1965 et 1983. Tr�s aim� des festivaliers et des professionnels qui y venaient en nombre le festival s''est peu � peu perdu dans une programmation radicale signant sa disparition...');
INSERT INTO cin_film VALUES (40, 'Club Zero', 2023, '1 h 50', '27/09/2023', 1, 'Jessica Hausner', 'Miss Novak rejoint un lyc�e priv� o� elle initie un cours de nutrition avec un concept innovant, bousculant les habitudes alimentaires. Sans qu''elle �veille les soup�ons des professeurs et des parents, certains �l�ves tombent sous son emprise et int�grent le cercle tr�s ferm� du myst�rieux Club...');
INSERT INTO cin_film VALUES (41, 'Dogman', 2023, '1 h 53', '27/09/2023', 1, 'Luc Besson', 'L''incroyable histoire d''un enfant, meurtri par la vie, qui trouvera son salut gr�ce � l''amour que lui portent ses chiens.');
INSERT INTO cin_film VALUES (42, 'Banlieusards 2', 2023, NULL, '27/09/2023', 1, 'Le�la Sy', 'Deux ans apr�s avoir fr�l� la mort, Demba tente de changer de vie. Noumouk� est impliqu� dans des rixes entre quartiers rivaux et Soulaymaan fait ses premiers pas en tant qu''avocat. Les 3 fr�res r�sisteront-ils � la vague de violence et � la brutalit� des �v�nements qui s''abattent sur eux ?');
INSERT INTO cin_film VALUES (43, 'Coup de chance', 2023, '1 h 33', '27/09/2023', 1, 'Woody Allen', 'Fanny et Jean ont tout du couple id�al : �panouis dans leur vie professionnelle, ils habitent un magnifique appartement dans les beaux quartiers de Paris et semblent amoureux comme au premier jour. Mais lorsque Fanny croise, par hasard, Alain, ancien camarade de lyc�e, elle est aussit�t chavir�e...');
INSERT INTO cin_film VALUES (44, 'Poisson rouge', 2023, '1 h 40', '27/09/2023', 1, 'Hugo Bachelet, Clement Vallos, Matthieu Yakovleff', 'Guillaume, 33 ans, perd la m�moire de fa�on irr�versible et va rentrer dans un centre sp�cialis�. Dans l''espoir de lui laisser un souvenir heureux, ses potes d''enfance lui organisent un dernier week-end festif. Ils se lancent dans un road trip qui permettra peut-�tre � Guillaume de r�gler ses...');
INSERT INTO cin_film VALUES (45, 'We Have a Dream', 2023, '1 h 33', '27/09/2023', 2, 'Pascal Plisson', 'Qui a dit que vivre avec un handicap signifiait renoncer � ses plus grands r�ves ? A travers le monde, Pascal Plisson est all� � la rencontre de Xavier, Charles, Antonio, Maud, Nirmala et Khendo, des enfants extraordinaires qui vont prouver que l''amour, l''�ducation inclusive, l''humour et le courage...');
INSERT INTO cin_film VALUES (46, 'Lost in the Night', 2023, '2 h 03', '04/10/2023', 1, 'Amat Escalante', 'Dans une petite ville du Mexique, Emiliano recherche les responsables de la disparition de sa m�re. Activiste �cologiste, elle s''opposait � l''industrie mini�re locale. Ne recevant aucune aide de la police ou du syst�me judiciaire, ses recherches le m�nent � la riche famille Aldama...');
INSERT INTO cin_film VALUES (47, 'MMXX', 2023, '2 h 40', '04/10/2023', 1, 'Cristi Puiu', 'Plusieurs portraits, quatre r�cits, quatre courts moments dans le temps qui capturent les errances d''un groupe d''�mes errantes coinc�es au carrefour de l''Histoire...');
INSERT INTO cin_film VALUES (48, 'Simetierre - Aux origines du mal', 2023, NULL, '07/10/2023', 1, 'Lindsey Beer', 'La mort est parfois pr�f�rable... En 1969, le jeune Jud Crandall r�ve de quitter sa ville natale de Ludlow, dans le Maine. Il y d�couvre de sinistres secrets enfouis et se trouve forc� d''affronter une sombre histoire de famille qui le maintiendra � jamais li� � Ludlow. En s''unissant, Jud et ses...');
INSERT INTO cin_film VALUES (49, 'Expendables 4', 2023, NULL, '11/10/2023', 1, 'Scott Waugh', 'La suite des aventures des Expendables.');
INSERT INTO cin_film VALUES (50, 'L''Exorciste - D�votion', 2023, '2 h 01', '11/10/2023', 1, 'David Gordon Green', 'Depuis la mort de sa femme enceinte, Victor Fielding �l�ve seul sa fille Angela. Mais lorsque l''adolescente et son amie Katherine disparaissent dans les bois pour revenir trois jours plus tard sans aucun souvenir de ce qui leur est arriv�, se d�clenche alors une cha�ne d''�v�nements qui obligera...');
INSERT INTO cin_film VALUES (51, 'Nina et le secret du h�risson', 2022, '1 h 22', '11/10/2023', 3, 'Alain Gagnol et Jean-Loup Felicioli', 'Nina aime �couter les histoires que lui raconte son p�re pour s''endormir, celles d''un h�risson qui d�couvre le monde. Un soir, son p�re, pr�occup� par son travail, ne vient pas lui conter une nouvelle aventure... Heureusement, son meilleur ami Mehdi est l� pour l''aider � trouver une solution : et...');
INSERT INTO cin_film VALUES (52, 'La Fianc�e du po�te', 2022, '1 h 43', '11/10/2023', 1, 'Yolande Moreau', 'Amoureuse de peinture et de po�sie, Mireille s''accommode de son travail de serveuse � la caf�t�ria des Beaux-Arts de Charleville tout en vivant de petits larcins et de trafic de cartouches de cigarettes. N''ayant pas les moyens d''entretenir la grande maison familiale des bords de Meuse dont elle...');
INSERT INTO cin_film VALUES (53, 'Marie-Line et son juge', 2023, NULL, '11/10/2023', 1, 'Jean-Pierre Am�ris', 'Marie-Line a 20 ans. Bien qu''elle ne connaisse que les petits boulots et la vie pr�caire, Marie-Line, est un vrai rayon de soleil. Sa rencontre avec un juge bougon et d�prim�, qui d�cide de l''engager comme chauffeur, va bouleverser sa vie.');
INSERT INTO cin_film VALUES (54, 'War Of The Worlds: The Attack', 2023, '1 h 25', '11/10/2023', 1, 'Tom Jolliffe', 'Trois jeunes amis traquent une m�t�orite �cras�e sur Terre. Ils d�couvrent rapidement qu''une invasion extraterrestre est imminente.');
INSERT INTO cin_film VALUES (55, 'Fair Play', 2023, '1 h 53', '13/10/2023', 1, 'Chloe Domont', 'Une promotion inattendue dans un fonds sp�culatif impitoyable pousse la relation d''un jeune couple au bord du gouffre, mena�ant de se d�faire bien plus que leurs r�cents fian�ailles.');
INSERT INTO cin_film VALUES (56, 'Les Trolls 3', 2023, NULL, '18/10/2023', 3, 'Tim Heitz et Colin Jack', 'Apr�s deux films � se tourner autour pour finalement tomber dans les bras l''un de l''autre, Poppy et Branch sont officiellement en couple (#broppy)! Alors qu''ils n''ont plus de secrets l''un pour l''autre, Poppy fait une d�couverte incroyable relative au pass� de Branch. � l''�poque, avec ses quatre...');
INSERT INTO cin_film VALUES (57, 'Linda veut du poulet !', 2023, '1 h 16', '18/10/2023', 3, 'Chiara Malta et S�bastien Laudenbach', 'Non, ce n''est pas Linda qui a pris la bague de sa m�re Paulette ! Cette punition est parfaitement injuste !� Et maintenant Paulette ferait tout pour se faire pardonner, m�me un poulet aux poivrons, elle qui ne sait pas cuisiner. Mais comment trouver un poulet un jour de gr�ve g�n�rale ?� De...');
INSERT INTO cin_film VALUES (58, 'American Carnage', 2022, '1 h 38', '18/10/2023', 1, 'Diego Hallivis', 'Apr�s la d�claration d''un d�cret d''un gouverneur visant � arr�ter les enfants d''immigrants sans papiers, les nouveaux d�tenus se voient offrir la possibilit� de faire annuler les charges qui p�sent sur eux en se portant volontaires pour s''occuper des personnes �g�es.');
INSERT INTO cin_film VALUES (59, 'Killers of the Flower Moon', 2023, '3 h 26', '18/10/2023', 1, 'Martin Scorsese', 'Au d�but du XX�me si�cle, le p�trole a apport� la fortune au peuple Osage qui, du jour au lendemain, est devenu l''un des plus riches du monde. La richesse de ces Am�rindiens attire aussit�t la convoitise de Blancs peu recommandables qui intriguent, soutirent et volent autant d''argent Osage que...');
INSERT INTO cin_film VALUES (60, 'Sacerdoce', 2023, '1 h 24', '18/10/2023', 2, 'Damien Boyer', 'Depuis des si�cles, les pr�tres accompagnent de nombreuses personnes dans leur vie, dans les moments de joie comme d''�preuve. Alors que le scandale des abus a entach� l''�glise ces derni�res ann�es, les pr�tres demeurent un myst�re. Plus qu''un simple m�tier, leur fonction exige un style de vie...');
INSERT INTO cin_film VALUES (61, 'Chambre 999', 2023, '1 h 25', '25/10/2023', 2, 'Lubna Playoust', ' Le cinema est-il un langage en train de se perdre, un art qui va mourir ? : Wim Wenders posait cette question � seize de ses coll�gues r�alisateurs dans Chambre 666 en 1982. Quarante ans plus tard, en 2022, Lubna Playoust utilise le m�me dispositif pour poser la m�me question � 30 cin�astes...');
INSERT INTO cin_film VALUES (62, 'Second Tour', 2023, '1 h 35', '25/10/2023', 1, 'Albert Dupontel', 'Journaliste politique en disgr�ce plac�e � la rubrique football, Mademoiselle Pove est sollicit�e pour suivre la campagne pr�sidentielle en cours. Le favori est un quinquag�naire, h�ritier d�une puissante famille fran�aise et novice en politique. Troubl�e par ce candidat qu�elle a connu moins lisse...');
INSERT INTO cin_film VALUES (63, 'The Pod Generation', 2023, '1 h 51', '25/10/2023', 1, 'Sophie Barthes', 'Dans un futur proche o� l''intelligence artificielle prend le pas sur la nature, Rachel et Alvy, couple new-yorkais, d�cident d''avoir un enfant. Un g�ant de la technologie, vantant les m�rites d''une maternit� plus simple et plus paritaire, propose aux futurs parents de porter l''enfant dans un POD...');
INSERT INTO cin_film VALUES (64, 'The Old Oak', 2023, '1 h 53', '25/10/2023', 1, 'Ken Loach', 'TJ Ballantyne est le propri�taire du "Old Oak", un pub qui est menac� de fermeture apr�s l''arriv�e de r�fugi�s syriens plac�s dans le village sans aucun pr�avis. Bient�t, TJ rencontre une jeune Syrienne, Yara, qui poss�de un appareil photo. Une amiti� va na�tre entre eux...');
INSERT INTO cin_film VALUES (65, 'Saw X', 2023, NULL, '25/10/2023', 1, 'Kevin Greutert', 'Atteint d''un cancer, John Kramer se rend au Mexique afin de subir une op�ration exp�rimentale capable de gu�rir sa maladie, mais il d�couvre que tout ceci n''est qu''une escroquerie visant des malades vuln�rables et afflig�s. Anim� d''un nouveau but, le c�l�bre tueur en s�rie retourne � son �uvre, et...');
INSERT INTO cin_film VALUES (66, '3 jours max', 2023, '1 h 30', '25/10/2023', 1, 'Tarek Boudali', 'La grand-m�re de Rayane a �t� kidnapp�e par un cartel mexicain et il a trois jours max pour la lib�rer.');
COMMIT;

INSERT INTO cin_estGenre VALUES (1, 23);
INSERT INTO cin_estGenre VALUES (1, 14);
INSERT INTO cin_estGenre VALUES (1, 32);
INSERT INTO cin_estGenre VALUES (2, 10);
INSERT INTO cin_estGenre VALUES (2, 18);
INSERT INTO cin_estGenre VALUES (3, 12);
INSERT INTO cin_estGenre VALUES (3, 20);
INSERT INTO cin_estGenre VALUES (4, 12);
INSERT INTO cin_estGenre VALUES (4, 16);
INSERT INTO cin_estGenre VALUES (4, 26);
INSERT INTO cin_estGenre VALUES (5, 12);
INSERT INTO cin_estGenre VALUES (5, 6);
INSERT INTO cin_estGenre VALUES (6, 12);
INSERT INTO cin_estGenre VALUES (6, 6);
INSERT INTO cin_estGenre VALUES (7, 12);
INSERT INTO cin_estGenre VALUES (7, 31);
INSERT INTO cin_estGenre VALUES (8, 12);
INSERT INTO cin_estGenre VALUES (9, 6);
INSERT INTO cin_estGenre VALUES (9, 12);
INSERT INTO cin_estGenre VALUES (9, 18);
INSERT INTO cin_estGenre VALUES (10, 2);
INSERT INTO cin_estGenre VALUES (10, 4);
INSERT INTO cin_estGenre VALUES (10, 9);
INSERT INTO cin_estGenre VALUES (11, 4);
INSERT INTO cin_estGenre VALUES (11, 12);
INSERT INTO cin_estGenre VALUES (11, 18);
INSERT INTO cin_estGenre VALUES (12, 1);
INSERT INTO cin_estGenre VALUES (12, 4);
INSERT INTO cin_estGenre VALUES (12, 9);
INSERT INTO cin_estGenre VALUES (13, 1);
INSERT INTO cin_estGenre VALUES (13, 4);
INSERT INTO cin_estGenre VALUES (13, 28);
INSERT INTO cin_estGenre VALUES (14, 2);
INSERT INTO cin_estGenre VALUES (14, 4);
INSERT INTO cin_estGenre VALUES (14, 9);
INSERT INTO cin_estGenre VALUES (15, 17);
INSERT INTO cin_estGenre VALUES (15, 12);
INSERT INTO cin_estGenre VALUES (16, 1);
INSERT INTO cin_estGenre VALUES (16, 4);
INSERT INTO cin_estGenre VALUES (17, 1);
INSERT INTO cin_estGenre VALUES (17, 4);
INSERT INTO cin_estGenre VALUES (17, 32);
INSERT INTO cin_estGenre VALUES (18, 6);
INSERT INTO cin_estGenre VALUES (18, 12);
INSERT INTO cin_estGenre VALUES (18, 18);
INSERT INTO cin_estGenre VALUES (19, 4);
INSERT INTO cin_estGenre VALUES (19, 9);
INSERT INTO cin_estGenre VALUES (19, 16);
INSERT INTO cin_estGenre VALUES (20, 32);
INSERT INTO cin_estGenre VALUES (21, 32);
INSERT INTO cin_estGenre VALUES (22, 1);
INSERT INTO cin_estGenre VALUES (22, 32);
INSERT INTO cin_estGenre VALUES (23, 9);
INSERT INTO cin_estGenre VALUES (23, 12);
INSERT INTO cin_estGenre VALUES (24, 25);
INSERT INTO cin_estGenre VALUES (24, 30);
INSERT INTO cin_estGenre VALUES (25, 12);
INSERT INTO cin_estGenre VALUES (25, 26);
INSERT INTO cin_estGenre VALUES (26, 2);
INSERT INTO cin_estGenre VALUES (26, 12);
INSERT INTO cin_estGenre VALUES (26, 16);
INSERT INTO cin_estGenre VALUES (27, 12);
INSERT INTO cin_estGenre VALUES (28, 32);
INSERT INTO cin_estGenre VALUES (28, 12);
INSERT INTO cin_estGenre VALUES (29, 9);
INSERT INTO cin_estGenre VALUES (29, 23);
INSERT INTO cin_estGenre VALUES (31, 10);
INSERT INTO cin_estGenre VALUES (32, 12);
INSERT INTO cin_estGenre VALUES (32, 32);
INSERT INTO cin_estGenre VALUES (33, 12);
INSERT INTO cin_estGenre VALUES (34, 30);
INSERT INTO cin_estGenre VALUES (35, 14);
INSERT INTO cin_estGenre VALUES (36, 12);
INSERT INTO cin_estGenre VALUES (36, 26);
INSERT INTO cin_estGenre VALUES (37, 9);
INSERT INTO cin_estGenre VALUES (38, 10);
INSERT INTO cin_estGenre VALUES (39, 8);
INSERT INTO cin_estGenre VALUES (39, 18);
INSERT INTO cin_estGenre VALUES (40, 12);
INSERT INTO cin_estGenre VALUES (40, 32);
INSERT INTO cin_estGenre VALUES (41, 12);
INSERT INTO cin_estGenre VALUES (42, 23);
INSERT INTO cin_estGenre VALUES (42, 12);
INSERT INTO cin_estGenre VALUES (43, 32);
INSERT INTO cin_estGenre VALUES (43, 12);
INSERT INTO cin_estGenre VALUES (43, 26);
INSERT INTO cin_estGenre VALUES (44, 9);
INSERT INTO cin_estGenre VALUES (44, 12);
INSERT INTO cin_estGenre VALUES (45, 30);
INSERT INTO cin_estGenre VALUES (46, 12);
INSERT INTO cin_estGenre VALUES (46, 32);
INSERT INTO cin_estGenre VALUES (47, 9);
INSERT INTO cin_estGenre VALUES (47, 12);
INSERT INTO cin_estGenre VALUES (48, 14);
INSERT INTO cin_estGenre VALUES (49, 1);
INSERT INTO cin_estGenre VALUES (49, 4);
INSERT INTO cin_estGenre VALUES (49, 32);
INSERT INTO cin_estGenre VALUES (50, 14);
INSERT INTO cin_estGenre VALUES (52, 12);
INSERT INTO cin_estGenre VALUES (53, 10);
INSERT INTO cin_estGenre VALUES (54, 14);
INSERT INTO cin_estGenre VALUES (54, 28);
INSERT INTO cin_estGenre VALUES (54, 32);
INSERT INTO cin_estGenre VALUES (55, 12);
INSERT INTO cin_estGenre VALUES (56, 2);
INSERT INTO cin_estGenre VALUES (56, 9);
INSERT INTO cin_estGenre VALUES (56, 16);
INSERT INTO cin_estGenre VALUES (57, 2);
INSERT INTO cin_estGenre VALUES (57, 9);
INSERT INTO cin_estGenre VALUES (57, 19);
INSERT INTO cin_estGenre VALUES (58, 32);
INSERT INTO cin_estGenre VALUES (58, 9);
INSERT INTO cin_estGenre VALUES (59, 12);
INSERT INTO cin_estGenre VALUES (59, 23);
INSERT INTO cin_estGenre VALUES (59, 32);
INSERT INTO cin_estGenre VALUES (60, 25);
INSERT INTO cin_estGenre VALUES (61, 8);
INSERT INTO cin_estGenre VALUES (62, 10);
INSERT INTO cin_estGenre VALUES (63, 9);
INSERT INTO cin_estGenre VALUES (63, 26);
INSERT INTO cin_estGenre VALUES (63, 28);
INSERT INTO cin_estGenre VALUES (65, 14);
INSERT INTO cin_estGenre VALUES (66, 1);
INSERT INTO cin_estGenre VALUES (66, 9);
COMMIT;

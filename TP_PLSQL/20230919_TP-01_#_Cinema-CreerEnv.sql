/* ----------------------------------------------------------------------------
Script : 62-31 - BDD-PL/SQL - 01-Cinema-CreerEnv.sql      Auteur : Ch. Stettler
Objet  : Création et remplissage des tables du cas Cinema
---------------------------------------------------------------------------- */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';  -- défini le format des dates

-- suppression des tables
DROP TABLE cin_estGenre;
DROP TABLE cin_film;
DROP TABLE cin_genre;
DROP TABLE cin_type;

-- création des tables de base
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

-- insertion des données initiales
INSERT INTO cin_type VALUES (1, 'Film');
INSERT INTO cin_type VALUES (2, 'Documentaire');
INSERT INTO cin_type VALUES (3, 'Long-métrage d''animation');

INSERT INTO cin_genre VALUES (1, 'Action');
INSERT INTO cin_genre VALUES (2, 'Animation');
INSERT INTO cin_genre VALUES (3, 'Art');
INSERT INTO cin_genre VALUES (4, 'Aventure');
INSERT INTO cin_genre VALUES (5, 'Barbare');
INSERT INTO cin_genre VALUES (6, 'Biopic');
INSERT INTO cin_genre VALUES (7, 'Catastrophe');
INSERT INTO cin_genre VALUES (8, 'Cinéma');
INSERT INTO cin_genre VALUES (9, 'Comédie');
INSERT INTO cin_genre VALUES (10, 'Comédie dramatique');
INSERT INTO cin_genre VALUES (11, 'Comédie romantique');
INSERT INTO cin_genre VALUES (12, 'Drame');
INSERT INTO cin_genre VALUES (13, 'Ecologie');
INSERT INTO cin_genre VALUES (14, 'Epouvante-Horreur');
INSERT INTO cin_genre VALUES (15, 'Expérimental');
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
INSERT INTO cin_genre VALUES (30, 'Société');
INSERT INTO cin_genre VALUES (31, 'Sport');
INSERT INTO cin_genre VALUES (32, 'Thriller');
COMMIT;

INSERT INTO cin_film VALUES (1, 'The Pale Blue Eye', 2022, '2 h 08', '06/01/2023', 1, 'Scott Cooper', '1830. Un détective chevronné enquête sur les meurtres qui ont eu lieu au sein de l''Académie militaire américaine de West Point, aidé par une jeune recrue méticuleuse qui deviendra plus tard un auteur mondialement connu, Edgar Allan Poe');
INSERT INTO cin_film VALUES (2, 'Babylon', 2022, '3 h 09', '18/01/2023', 1, 'Damien Chazelle', 'Los Angeles des années 1920. Récit d''une ambition démesurée et d''excès les plus fous, l''ascension et la chute de différents personnages lors de la création d''Hollywood, une ère de décadence et de dépravation sans limites.');
INSERT INTO cin_film VALUES (3, 'TÁR', 2022, '2 h 38', '25/01/2023', 1, 'Todd Field', 'Lydia Tár, cheffe avant-gardiste d''un grand orchestre symphonique allemand, est au sommet de son art et de sa carrière. Le lancement de son livre approche et elle prépare un concert très attendu de la célèbre Symphonie n° 5 de Gustav Mahler. Mais, en l''espace de quelques semaines, sa vie va se désagréger d''une façon singulièrement actuelle');
INSERT INTO cin_film VALUES (4, 'La Montagne', 2022, '1 h 52', '01/02/2023', 1, 'Thomas Salvador', 'Pierre, ingénieur parisien, se rend dans les Alpes pour son travail. Irrésistiblement attiré par les montagnes, il s''installe un bivouac en altitude et décide de ne plus redescendre. Là-haut, il fait la rencontre de Léa et découvre de mystérieuses lueurs');
INSERT INTO cin_film VALUES (5, 'La Femme de Tchaïkovski', 2022, '2 h 23', '15/02/2023', 1, 'Kirill Serebrennikov', 'Russie, 19ème siècle. Antonina Miliukova, jeune femme aisée et brillante, épouse le compositeur Piotr Tchaïkovski. Mais l''amour qu''elle lui porte tourne à l''obsession et la jeune femme est violemment rejetée. Consumée par ses sentiments, Antonina accepte de tout endurer pour rester auprès de lui');
INSERT INTO cin_film VALUES (6, 'The Fabelmans', 2022, '2 h 31', '22/02/2023', 1, 'Steven Spielberg', 'Le jeune Sammy Fabelman tombe amoureux du cinéma après que ses parents l''ont emmené voir "The Greatest Show on Earth". Armé d''une caméra, Sammy commence à faire ses propres films à la maison, pour le plus grand plaisir de sa mère qui le soutient.');
INSERT INTO cin_film VALUES (7, 'Creed III', 2023, '1 h 56', '01/03/2023', 1, 'Michael B. Jordan', 'Idole de la boxe et entouré de sa famille, Adonis Creed n''a plus rien à prouver. Jusqu''au jour où son ami d''enfance, Damian, prodige de la boxe lui aussi, refait surface. A peine sorti de prison, Damian est prêt à tout pour monter sur le ring et reprendre ses droits');
INSERT INTO cin_film VALUES (8, 'The Whale', 2022, '1 h 57', '08/03/2023', 1, 'Darren Aronofsky', 'Charlie, professeur d''anglais reclus chez lui, tente de renouer avec sa fille adolescente pour une ultime chance de rédemption');
INSERT INTO cin_film VALUES (9, 'Tetris', 2023, '1 h 58', '31/03/2023', 1, 'Jon S. Baird', 'Tiré de la vraie histoire du développeur et promoteur de jeux vidéo Henk Rogers et de sa rencontre avec Tetris en 1988. Lorsqu''il entreprend de faire connaître ce jeu au monde entier, il plonge dans une dangereuse spirale de mensonges et de corruption derrière le rideau de fer soviétique');
INSERT INTO cin_film VALUES (10, 'Super Mario Bros, le film', 2023, '1 h 32', '05/04/2023', 3, 'Aaron Horvath et Michael Jelenic', 'Alors qu''ils tentent de réparer une canalisation souterraine, Mario et son frère Luigi, tous deux plombiers, se retrouvent plongés dans un nouvel univers féerique à travers un mystérieux conduit. Mais lorsque les deux frères sont séparés, Mario s''engage dans une aventure trépidante pour retrouver son frère');
INSERT INTO cin_film VALUES (11, 'Les Trois Mousquetaires - D''Artagnan', 2023, '2 h 01', '05/04/2023', 1, 'Martin Bourboulon', 'Beau tente désespérément de rejoindre sa mère. Mais l''univers semble se liguer contre lui');
INSERT INTO cin_film VALUES (12, 'Les Gardiens de la galaxie Vol. 3', 2023, '2 h 30', '03/05/2023', 1, 'James Gunn', 'Notre bande de marginaux favorite a quelque peu changé. Peter Quill, qui pleure toujours la perte de Gamora, doit rassembler son équipe pour défendre l''univers et protéger l''un des siens. En cas d''échec, cette mission pourrait bien marquer la fin des Gardiens tels que nous les connaissons.');
INSERT INTO cin_film VALUES (13, 'Spider-Man: Across the Spider-Verse', 2023, '2 h 20', '31/05/2023', 3, 'Joaquim Dos Santos, Kemp Powers et Justin Thompson', 'Après avoir retrouvé Gwen Stacy, Spider-Man, le sympathique héros originaire de Brooklyn, est catapulté à travers le Multivers, où il rencontre une équipe de Spider-Héros chargée d''en protéger l''existence. Mais lorsque les héros s''opposent sur la façon de gérer une nouvelle menace, Miles se retrouve confronté à eux et doit redéfinir ce que signifie être un héros afin de sauver les personnes qu''il aime le plus.');
INSERT INTO cin_film VALUES (14, 'Élémentaire', 2023, '1 h 42', '21/06/2023', 3, 'Peter Sohn', 'Dans la ville d''Element City, le feu, l''eau, la terre et l''air vivent dans la plus parfaite harmonie. C''est ici que résident Flam, une jeune femme intrépide et vive d''esprit, au caractère bien trempé, et Flack, un garçon sentimental et amusant, plutôt suiveur dans l''âme. L''amitié qu''ils se portent remet en question les croyances de Flam sur le monde dans lequel ils vivent');
INSERT INTO cin_film VALUES (15, 'The Covenant', 2023, '2 h 03', '23/06/2023', 1, 'Guy Ritchie', 'Lors de sa dernière mission en Afghanistan, le sergent John Kinley fait équipe avec l''interprète Ahmed pour arpenter la région. Lorsque leur unité tombe dans une embuscade au cours d''une patrouille, Kinley et Ahmed sont les seuls survivants. Alors que des combattants ennemis les poursuivent, Ahmed risque sa vie pour transporter Kinley, blessé, en sécurité. De retour sur le sol américain, Kinley apprend qu''Ahmed et sa famille n''ont pas obtenu la possibilité d''entrer aux Etats-Unis');
INSERT INTO cin_film VALUES (16, 'Indiana Jones et le cadran de la destinée', 2023, '2 h 34', '28/06/2023', 1, 'James Mangold', 'En 1969, l''archéologue et aventurier américan Indiana Jones est opposé à la course à l''espace en raison du fait que les États-Unis ont recruté d''anciens nazis pour battre l''Union Soviétique dans cette compétition. Sa filleule Helena l''accompagne dans ce combat. Pendant ce temps, Jürgen Voller, un employé de la NASA et ex-nazi impliqué dans le programme lunaire cherche à rendre le monde meilleur à son idée');
INSERT INTO cin_film VALUES (17, 'Mission: Impossible - Dead Reckoning Partie 1', 2023, '2 h 43', '12/07/2023', 1, 'Christopher McQuarrie', 'Le contrôle du futur et le destin du monde sont en jeu. Alors que les forces obscures de son passé ressurgissent, Ethan s''engage dans une course mortelle autour du globe. Confronté à un puissant et énigmatique ennemi, Ethan réalise que rien ne peut se placer au-dessus de sa mission - pas même la vie de ceux qu''il aime');
INSERT INTO cin_film VALUES (18, 'Oppenheimer', 2023, '3 h', '19/07/2023', 1, 'Christopher Nolan', 'En 1942, convaincus que l''Allemagne nazie est en train de développer une arme nucléaire, les États-Unis initient, dans le plus grand secret, le "Projet Manhattan" destiné à mettre au point la première bombe atomique de l''histoire. Pour piloter ce dispositif, le gouvernement engage J. Robert Oppenheimer, brillant physicien, qui sera bientôt surnommé "le père de la bombe atomique". C''est dans le laboratoire ultra-secret de Los Alamos, au cœur du désert du Nouveau-Mexique, ...');
INSERT INTO cin_film VALUES (19, 'Barbie', 2023, '1 h 54', '19/07/2023', 1, 'Greta Gerwig', 'À Barbie Land, vous êtes un être parfait dans un monde parfait. Sauf si vous êtes en crise existentielle, ou si vous êtes Ken');
INSERT INTO cin_film VALUES (20, 'Un jour et demi', 2023, '1 h 30', '01/09/2023', 1, 'Fares Fares', 'Pour retrouver sa fille, Artan prend son ex-femme Louise en otage et l''embarque, elle et le négociateur de crise Lukas, dans un road trip intense et riche en émotions. Ensemble, ils traversent la campagne suédoise au coeur de l''été, avec la police à leurs trousses.');
INSERT INTO cin_film VALUES (21, 'Live stream', 2023, '1 h 30', '01/09/2023', 1, '', 'Un producteur de télévision indépendant reçoit un lien vers une caméra espion de sa propre petite amie.Il décide de prendre les choses en main et de la sauver, mais sombre dans le monde miteux des émissions illégales.');
INSERT INTO cin_film VALUES (22, 'Kandahar', 2023, '1 h 59', '01/09/2023', 1, 'Ric Roman Waugh', 'Tom Harris est un agent secret de la CIA travaillant au Moyen-Orient. Une fuite des renseignements révèle son identité. Coincés au cœur d''un territoire hostile, Harris et son traducteur doivent se frayer un chemin hors du désert jusqu''à Kandahar, en Afghanistan, tout en échappant aux forces...');
INSERT INTO cin_film VALUES (23, 'The Adults', 2023, '1 h 31', '04/09/2023', 1, 'Dustin Guy Defa', 'Alors qu''Eric rentre chez lui pour une courte visite, il se retrouve coincé entre rattraper le temps perdu avec ses sœurs et courir après une victoire avec son ancien groupe de poker.');
INSERT INTO cin_film VALUES (24, 'Transfariana', 2023, NULL, '04/09/2023', 1, 'Joris Lachaise', 'L''histoire d''amour inattendue entre une ancienne travailleuse du sexe trans et un rebelle des FARC commencée dans une prison colombienne et qui a débouché sur une alliance entre des militants trans et des militants des FARC qui ont déposé les armes.');
INSERT INTO cin_film VALUES (25, 'Le Ciel rouge', 2023, '1 h 42', '06/09/2023', 1, 'Christian Petzold', 'Une petite maison de vacances au bord de la mer Baltique. Les journées sont chaudes et il n''a pas plu depuis des semaines. Quatre jeunes gens se réunissent, des amis anciens et nouveaux. Les forêts desséchées qui les entourent commencent à s''enflammer, tout comme leurs émotions. Le bonheur, la...');
INSERT INTO cin_film VALUES (26, 'Le Château solitaire dans le miroir', 2022, '1 h 56', '06/09/2023', 3, 'Keiichi Hara', 'Un beau jour, le miroir dans la chambre de Kokoro se met à scintiller. À peine la jeune fille l''a-t-elle effleuré qu''elle se retrouve dans un formidable château digne d''un conte de fées. Là, une mystérieuse fillette affublée d''un masque de loup lui soumet un défi. Elle a un an pour l''accomplir et...');
INSERT INTO cin_film VALUES (27, 'Anti-Squat', 2023, '1 h 35', '06/09/2023', 1, 'Nicolas Silhol', 'Inès est menacée de se faire expulser de chez elle avec Adam, son fils de 14 ans. A la recherche d''un emploi, elle est prise à l''essai chez Anti-Squat, une société qui loge des personnes dans des bureaux inoccupés pour les protéger contre les squatteurs. Son rôle : recruter les résidents et faire...');
INSERT INTO cin_film VALUES (28, 'Visions', 2023, '2 h 03', '06/09/2023', 1, 'Yann Gozlan', 'Pilote de ligne confirmée, Estelle mène, entre deux vols long-courriers, une vie parfaite avec Guillaume, son mari aimant et protecteur. Un jour, par hasard, dans un couloir d''aéroport, elle recroise la route d''Ana, photographe avec qui elle a eu une aventure passionnée vingt ans plus tôt. Estelle...');
INSERT INTO cin_film VALUES (29, 'Sentinelle', 2023, NULL, '08/09/2023', 1, 'Hugo Benamozig et David Caviglioli', 'François Sentinelle mène une double vie. Le jour, il est le flic le plus médiatique de l''Île de la Réunion, connu pour ses méthodes musclées et ses chemises à fleur, poursuivant les criminels à bord de son célèbre defender jaune. Mais hors des heures de service (et bien souvent pendant), Sentinelle...');
INSERT INTO cin_film VALUES (30, 'Le monde selon mon père', 2023, '1 h 55', '13/09/2023', 1, 'Petra Seeger', 'À la lumière de photos de famille prises par son père, une femme se remémore son adolescence dans l''Allemagne des années 1960.');
INSERT INTO cin_film VALUES (31, 'Un métier sérieux', 2023, '1 h 41', '13/09/2023', 1, 'Thomas Lilti', 'C''est la rentrée. Une nouvelle année scolaire au collège qui voit se retrouver Pierre, Meriem, Fouad, Sophie, Sandrine, Alix et Sofiane, un groupe d''enseignants engagés et soudés. Ils sont rejoints par Benjamin, jeune professeur remplaçant sans expérience et rapidement confronté aux affres du...');
INSERT INTO cin_film VALUES (32, 'L''Été dernier', 2023, '1 h 44', '13/09/2023', 1, 'Catherine Breillat', 'Anne, avocate renommée, vit en harmonie avec son mari Pierre et leurs filles de 6 et 7 ans. Un jour, Théo, 17 ans, fils de Pierre d''un précédent mariage, emménage chez eux. Peu de temps après, il annonce à son père qu''il a une liaison avec Anne. Elle nie.');
INSERT INTO cin_film VALUES (33, 'Le Grand Chariot', 2023, '1 h 35', '13/09/2023', 1, 'Philippe Garrel', 'La destinée romanesque et tragique d''une fratrie d''artistes marionnettistes.');
INSERT INTO cin_film VALUES (34, 'Loup y es-tu ?', 2021, '1 h 26', '13/09/2023', 2, 'Clara Bouffartigue', 'Souvent adressés par l''école, les enfants et leurs parents arrivent au Centre Claude Bernard avec leur échec en bandoulière, sous le manteau ou sous la peau, c''est selon, mais toujours avec cette souffrance dont ils s''accommodent mal. Qu''est-ce que cette fatalité qui s''abat sur notre famille ? Il...');
INSERT INTO cin_film VALUES (35, 'Noctambule', 2023, '30 min', '16/09/2023', 1, 'Adrien Caulier', 'Une jeune femme décide de rentrer chez elle le soir lorsqu''elle ressent un profond malaise lors de la fête chez une amie. C''est alors qu''une étrange silhouette va commencer à la suivre...');
INSERT INTO cin_film VALUES (36, 'Ma promesse', 2019, '1 h 56', '20/09/2023', 1, 'Martha Coolidge', 'Robert est un chanteur d''opéra catholique et Rachel, une violoniste juive. Ils rêvent de se produire un jour ensemble au Carnegie Hall. Lorsqu''ils sont séparés par l''invasion allemande de la Pologne, Robert jure de retrouver Rachel, quoi qu''il arrive. Sa quête l''entraîne dans un voyage au cœur de...');
INSERT INTO cin_film VALUES (37, 'Last Dance !', 2022, '1 h 23', '20/09/2023', 1, 'Delphine Lehericey', 'Retraité contemplatif, Germain se retrouve soudainement veuf à 75 ans. Il n''a même pas le temps de souffler que sa famille s''immisce dans son quotidien : visites et appels incessants, repas organisés à l''avance… Sa vie devient réglée comme une montre suisse ! Mais Germain a l''esprit ailleurs...');
INSERT INTO cin_film VALUES (38, 'Déserts', 2023, '2 h 06', '20/09/2023', 1, 'Faouzi Bensaïdi', 'Mehdi et Hamid travaillent pour une agence de recouvrement à Casablanca. Les deux pieds nickelés arpentent des villages lointains du grand sud marocain pour soutirer de l''argent à des familles surendettées...');
INSERT INTO cin_film VALUES (39, 'Jeune cinéma', 2022, '1 h 13', '27/09/2023', 2, 'Yves-Marie Mahe', 'Jeune cinéma est un documentaire d''archives sur le mythique festival de cinéma d''Hyères qui eut lieu entre 1965 et 1983. Très aimé des festivaliers et des professionnels qui y venaient en nombre le festival s''est peu à peu perdu dans une programmation radicale signant sa disparition...');
INSERT INTO cin_film VALUES (40, 'Club Zero', 2023, '1 h 50', '27/09/2023', 1, 'Jessica Hausner', 'Miss Novak rejoint un lycée privé où elle initie un cours de nutrition avec un concept innovant, bousculant les habitudes alimentaires. Sans qu''elle éveille les soupçons des professeurs et des parents, certains élèves tombent sous son emprise et intègrent le cercle très fermé du mystérieux Club...');
INSERT INTO cin_film VALUES (41, 'Dogman', 2023, '1 h 53', '27/09/2023', 1, 'Luc Besson', 'L''incroyable histoire d''un enfant, meurtri par la vie, qui trouvera son salut grâce à l''amour que lui portent ses chiens.');
INSERT INTO cin_film VALUES (42, 'Banlieusards 2', 2023, NULL, '27/09/2023', 1, 'Leïla Sy', 'Deux ans après avoir frôlé la mort, Demba tente de changer de vie. Noumouké est impliqué dans des rixes entre quartiers rivaux et Soulaymaan fait ses premiers pas en tant qu''avocat. Les 3 frères résisteront-ils à la vague de violence et à la brutalité des évènements qui s''abattent sur eux ?');
INSERT INTO cin_film VALUES (43, 'Coup de chance', 2023, '1 h 33', '27/09/2023', 1, 'Woody Allen', 'Fanny et Jean ont tout du couple idéal : épanouis dans leur vie professionnelle, ils habitent un magnifique appartement dans les beaux quartiers de Paris et semblent amoureux comme au premier jour. Mais lorsque Fanny croise, par hasard, Alain, ancien camarade de lycée, elle est aussitôt chavirée...');
INSERT INTO cin_film VALUES (44, 'Poisson rouge', 2023, '1 h 40', '27/09/2023', 1, 'Hugo Bachelet, Clement Vallos, Matthieu Yakovleff', 'Guillaume, 33 ans, perd la mémoire de façon irréversible et va rentrer dans un centre spécialisé. Dans l''espoir de lui laisser un souvenir heureux, ses potes d''enfance lui organisent un dernier week-end festif. Ils se lancent dans un road trip qui permettra peut-être à Guillaume de régler ses...');
INSERT INTO cin_film VALUES (45, 'We Have a Dream', 2023, '1 h 33', '27/09/2023', 2, 'Pascal Plisson', 'Qui a dit que vivre avec un handicap signifiait renoncer à ses plus grands rêves ? A travers le monde, Pascal Plisson est allé à la rencontre de Xavier, Charles, Antonio, Maud, Nirmala et Khendo, des enfants extraordinaires qui vont prouver que l''amour, l''éducation inclusive, l''humour et le courage...');
INSERT INTO cin_film VALUES (46, 'Lost in the Night', 2023, '2 h 03', '04/10/2023', 1, 'Amat Escalante', 'Dans une petite ville du Mexique, Emiliano recherche les responsables de la disparition de sa mère. Activiste écologiste, elle s''opposait à l''industrie minière locale. Ne recevant aucune aide de la police ou du système judiciaire, ses recherches le mènent à la riche famille Aldama...');
INSERT INTO cin_film VALUES (47, 'MMXX', 2023, '2 h 40', '04/10/2023', 1, 'Cristi Puiu', 'Plusieurs portraits, quatre récits, quatre courts moments dans le temps qui capturent les errances d''un groupe d''âmes errantes coincées au carrefour de l''Histoire...');
INSERT INTO cin_film VALUES (48, 'Simetierre - Aux origines du mal', 2023, NULL, '07/10/2023', 1, 'Lindsey Beer', 'La mort est parfois préférable... En 1969, le jeune Jud Crandall rêve de quitter sa ville natale de Ludlow, dans le Maine. Il y découvre de sinistres secrets enfouis et se trouve forcé d''affronter une sombre histoire de famille qui le maintiendra à jamais lié à Ludlow. En s''unissant, Jud et ses...');
INSERT INTO cin_film VALUES (49, 'Expendables 4', 2023, NULL, '11/10/2023', 1, 'Scott Waugh', 'La suite des aventures des Expendables.');
INSERT INTO cin_film VALUES (50, 'L''Exorciste - Dévotion', 2023, '2 h 01', '11/10/2023', 1, 'David Gordon Green', 'Depuis la mort de sa femme enceinte, Victor Fielding élève seul sa fille Angela. Mais lorsque l''adolescente et son amie Katherine disparaissent dans les bois pour revenir trois jours plus tard sans aucun souvenir de ce qui leur est arrivé, se déclenche alors une chaîne d''événements qui obligera...');
INSERT INTO cin_film VALUES (51, 'Nina et le secret du hérisson', 2022, '1 h 22', '11/10/2023', 3, 'Alain Gagnol et Jean-Loup Felicioli', 'Nina aime écouter les histoires que lui raconte son père pour s''endormir, celles d''un hérisson qui découvre le monde. Un soir, son père, préoccupé par son travail, ne vient pas lui conter une nouvelle aventure... Heureusement, son meilleur ami Mehdi est là pour l''aider à trouver une solution : et...');
INSERT INTO cin_film VALUES (52, 'La Fiancée du poète', 2022, '1 h 43', '11/10/2023', 1, 'Yolande Moreau', 'Amoureuse de peinture et de poésie, Mireille s''accommode de son travail de serveuse à la cafétéria des Beaux-Arts de Charleville tout en vivant de petits larcins et de trafic de cartouches de cigarettes. N''ayant pas les moyens d''entretenir la grande maison familiale des bords de Meuse dont elle...');
INSERT INTO cin_film VALUES (53, 'Marie-Line et son juge', 2023, NULL, '11/10/2023', 1, 'Jean-Pierre Améris', 'Marie-Line a 20 ans. Bien qu''elle ne connaisse que les petits boulots et la vie précaire, Marie-Line, est un vrai rayon de soleil. Sa rencontre avec un juge bougon et déprimé, qui décide de l''engager comme chauffeur, va bouleverser sa vie.');
INSERT INTO cin_film VALUES (54, 'War Of The Worlds: The Attack', 2023, '1 h 25', '11/10/2023', 1, 'Tom Jolliffe', 'Trois jeunes amis traquent une météorite écrasée sur Terre. Ils découvrent rapidement qu''une invasion extraterrestre est imminente.');
INSERT INTO cin_film VALUES (55, 'Fair Play', 2023, '1 h 53', '13/10/2023', 1, 'Chloe Domont', 'Une promotion inattendue dans un fonds spéculatif impitoyable pousse la relation d''un jeune couple au bord du gouffre, menaçant de se défaire bien plus que leurs récents fiançailles.');
INSERT INTO cin_film VALUES (56, 'Les Trolls 3', 2023, NULL, '18/10/2023', 3, 'Tim Heitz et Colin Jack', 'Après deux films à se tourner autour pour finalement tomber dans les bras l''un de l''autre, Poppy et Branch sont officiellement en couple (#broppy)! Alors qu''ils n''ont plus de secrets l''un pour l''autre, Poppy fait une découverte incroyable relative au passé de Branch. À l''époque, avec ses quatre...');
INSERT INTO cin_film VALUES (57, 'Linda veut du poulet !', 2023, '1 h 16', '18/10/2023', 3, 'Chiara Malta et Sébastien Laudenbach', 'Non, ce n''est pas Linda qui a pris la bague de sa mère Paulette ! Cette punition est parfaitement injuste !… Et maintenant Paulette ferait tout pour se faire pardonner, même un poulet aux poivrons, elle qui ne sait pas cuisiner. Mais comment trouver un poulet un jour de grève générale ?… De...');
INSERT INTO cin_film VALUES (58, 'American Carnage', 2022, '1 h 38', '18/10/2023', 1, 'Diego Hallivis', 'Après la déclaration d''un décret d''un gouverneur visant à arrêter les enfants d''immigrants sans papiers, les nouveaux détenus se voient offrir la possibilité de faire annuler les charges qui pèsent sur eux en se portant volontaires pour s''occuper des personnes âgées.');
INSERT INTO cin_film VALUES (59, 'Killers of the Flower Moon', 2023, '3 h 26', '18/10/2023', 1, 'Martin Scorsese', 'Au début du XXème siècle, le pétrole a apporté la fortune au peuple Osage qui, du jour au lendemain, est devenu l''un des plus riches du monde. La richesse de ces Amérindiens attire aussitôt la convoitise de Blancs peu recommandables qui intriguent, soutirent et volent autant d''argent Osage que...');
INSERT INTO cin_film VALUES (60, 'Sacerdoce', 2023, '1 h 24', '18/10/2023', 2, 'Damien Boyer', 'Depuis des siècles, les prêtres accompagnent de nombreuses personnes dans leur vie, dans les moments de joie comme d''épreuve. Alors que le scandale des abus a entaché l''Église ces dernières années, les prêtres demeurent un mystère. Plus qu''un simple métier, leur fonction exige un style de vie...');
INSERT INTO cin_film VALUES (61, 'Chambre 999', 2023, '1 h 25', '25/10/2023', 2, 'Lubna Playoust', ' Le cinema est-il un langage en train de se perdre, un art qui va mourir ? : Wim Wenders posait cette question à seize de ses collègues réalisateurs dans Chambre 666 en 1982. Quarante ans plus tard, en 2022, Lubna Playoust utilise le même dispositif pour poser la même question à 30 cinéastes...');
INSERT INTO cin_film VALUES (62, 'Second Tour', 2023, '1 h 35', '25/10/2023', 1, 'Albert Dupontel', 'Journaliste politique en disgrâce placée à la rubrique football, Mademoiselle Pove est sollicitée pour suivre la campagne présidentielle en cours. Le favori est un quinquagénaire, héritier d’une puissante famille française et novice en politique. Troublée par ce candidat qu’elle a connu moins lisse...');
INSERT INTO cin_film VALUES (63, 'The Pod Generation', 2023, '1 h 51', '25/10/2023', 1, 'Sophie Barthes', 'Dans un futur proche où l''intelligence artificielle prend le pas sur la nature, Rachel et Alvy, couple new-yorkais, décident d''avoir un enfant. Un géant de la technologie, vantant les mérites d''une maternité plus simple et plus paritaire, propose aux futurs parents de porter l''enfant dans un POD...');
INSERT INTO cin_film VALUES (64, 'The Old Oak', 2023, '1 h 53', '25/10/2023', 1, 'Ken Loach', 'TJ Ballantyne est le propriétaire du "Old Oak", un pub qui est menacé de fermeture après l''arrivée de réfugiés syriens placés dans le village sans aucun préavis. Bientôt, TJ rencontre une jeune Syrienne, Yara, qui possède un appareil photo. Une amitié va naître entre eux...');
INSERT INTO cin_film VALUES (65, 'Saw X', 2023, NULL, '25/10/2023', 1, 'Kevin Greutert', 'Atteint d''un cancer, John Kramer se rend au Mexique afin de subir une opération expérimentale capable de guérir sa maladie, mais il découvre que tout ceci n''est qu''une escroquerie visant des malades vulnérables et affligés. Animé d''un nouveau but, le célèbre tueur en série retourne à son œuvre, et...');
INSERT INTO cin_film VALUES (66, '3 jours max', 2023, '1 h 30', '25/10/2023', 1, 'Tarek Boudali', 'La grand-mère de Rayane a été kidnappée par un cartel mexicain et il a trois jours max pour la libérer.');
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

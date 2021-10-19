--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE A OWNED_VEHICLES TABLE ALREADY.
CREATE TABLE `owned_vehicles` (
	`owner` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_bin',
	`plate` VARCHAR(12) NOT NULL COLLATE 'utf8mb4_bin',
	`vehicle` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`impound` INT(1) NOT NULL DEFAULT '0',
	`stored` INT(1) NOT NULL DEFAULT '0',
	`garage_type` VARCHAR(50) NULL DEFAULT 'car' COLLATE 'utf8mb4_bin',
	`garage_id` VARCHAR(50) NULL DEFAULT 'A' COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`plate`) USING BTREE,
	INDEX `vehsowned` (`owner`) USING BTREE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE vehicles
ADD shop varchar(32) NOT NULL DEFAULT 'pdm';

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE vehicles
ADD stock int(11) NOT NULL DEFAULT 100;

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE owned_vehicles
ADD `type` varchar(32) NOT NULL DEFAULT 'car';

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE owned_vehicles
ADD `garage_id` varchar(32) NOT NULL DEFAULT 'A';

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE owned_vehicles
ADD job varchar(32) NOT NULL DEFAULT 'civ';

--ADD THIS TO YOUR TABLE IF YOU DO NOT HAVE this column.

ALTER TABLE owned_vehicles
ADD `stored` varchar(32) NOT NULL DEFAULT 1;

REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
	('Adder', 'adder', 900000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Akuma', 'AKUMA', 7500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Alpha', 'alpha', 60000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('asbo', 'asbo', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Asea', 'asea', 5500, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('asterope', 'asterope', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Autarch', 'autarch', 1955000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Avarus', 'avarus', 18000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bagger', 'bagger', 13500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Baller', 'baller2', 40000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Baller Sport', 'baller3', 60000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Baller Sport', 'baller4', 60000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Banshee', 'banshee', 70000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Banshee 900R', 'banshee2', 255000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bati 801', 'bati', 12000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bati 801RR', 'bati2', 19000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bestia GTS', 'bestiagts', 55000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('BF400', 'bf400', 6500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bf Injection', 'bfinjection', 16000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bifta', 'bifta', 12000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bison', 'bison', 45000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('bison2', 'bison2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('bjxl', 'bjxl', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Blade', 'blade', 15000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Blazer', 'blazer', 6500, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Blazer Sport', 'blazer4', 8500, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Blista', 'blista', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('blista2', 'blista2', 45000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('blista3', 'blista3', 45000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('BMX', 'bmx', 160, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bobcat XL', 'bobcatxl', 32000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('bodhi2', 'bodhi2', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Brawler', 'brawler', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Brioso R/A', 'brioso', 18000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('brioso2', 'brioso2', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Btype', 'btype', 62000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Btype Hotroad', 'btype2', 155000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Btype Luxe', 'btype3', 85000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Buccaneer', 'buccaneer', 18000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Buccaneer Rider', 'buccaneer2', 24000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Buffalo', 'buffalo', 12000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Buffalo S', 'buffalo2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Buffalo3', 'buffalo3', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bullet', 'bullet', 90000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('burrito2', 'burrito2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Burrito', 'burrito3', 19000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('burrito4', 'burrito4', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Camper', 'camper', 42000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Carbonizzare', 'carbonizzare', 75000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Carbon RS', 'carbonrs', 18000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Casco', 'casco', 30000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('cavalcade', 'cavalcade', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cavalcade', 'cavalcade2', 55000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cheburek', 'cheburek', 20000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cheetah', 'cheetah', 375000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('cheetah2', 'cheetah2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Chimera', 'chimera', 38000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Chino', 'chino', 15000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Chino Luxe', 'chino2', 19000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cliffhanger', 'cliffhanger', 9500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('clique', 'clique', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('club', 'club', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('cog55', 'cog55', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cognoscenti Cabrio', 'cogcabrio', 55000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cognoscenti', 'cognoscenti', 55000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Comet', 'comet2', 65000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Comet 5', 'comet5', 145000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Contender', 'contender', 70000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Coquette', 'coquette', 65000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Coquette Classic', 'coquette2', 40000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Coquette BlackFin', 'coquette3', 55000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cruiser', 'cruiser', 510, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Cyclone', 'cyclone', 1890000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Daemon', 'daemon', 11500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Daemon High', 'daemon2', 13500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Defiler', 'defiler', 9800, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('deveste', 'deveste', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('deviant', 'deviant', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('diablous', 'diablous', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('diablous2', 'diablous2', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dilettante', 'dilettante', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dloader', 'dloader', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Dominator', 'dominator', 35000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dominator2', 'dominator2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dominator3', 'dominator3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Double T', 'double', 28000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('drafter', 'drafter', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Dubsta', 'dubsta', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Dubsta Luxuary', 'dubsta2', 60000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Bubsta 6x6', 'dubsta3', 120000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Dukes', 'dukes', 28000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dukes3', 'dukes3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Dune Buggy', 'dune', 8000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dynasty', 'dynasty', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('elegy', 'elegy', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Elegy', 'elegy2', 38500, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ellie', 'ellie', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('emerus', 'emerus', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Emperor', 'emperor', 8500, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('emperor2', 'emperor2', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Enduro', 'enduro', 5500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('entity2', 'entity2', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Entity XF', 'entityxf', 425000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Esskey', 'esskey', 4200, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('everon', 'everon', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Exemplar', 'exemplar', 32000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('F620', 'f620', 40000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Faction', 'faction', 20000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Faction Rider', 'faction2', 30000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('fagaloa', 'fagaloa', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Faggio', 'faggio', 1900, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Vespa', 'faggio2', 2800, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('faggio3', 'faggio3', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('fcr', 'fcr', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('fcr2', 'fcr2', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Felon', 'felon', 42000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Felon GT', 'felon2', 55000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Feltzer', 'feltzer2', 55000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Stirling GT', 'feltzer3', 65000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Fixter', 'fixter', 225, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('flashgt', 'flashgt', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('FMJ', 'fmj', 185000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Fhantom', 'fq2', 17000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('freecrawler', 'freecrawler', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Fugitive', 'fugitive', 12000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('furia', 'furia', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Furore GT', 'furoregt', 45000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Fusilade', 'fusilade', 40000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('futo', 'futo', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Gargoyle', 'gargoyle', 16500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Gauntlet', 'gauntlet', 30000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gauntlet2', 'gauntlet2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gauntlet3', 'gauntlet3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gauntlet4', 'gauntlet4', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gauntlet5', 'gauntlet5', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gb200', 'gb200', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Gang Burrito', 'gburrito', 45000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Burrito', 'gburrito2', 29000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Glendale', 'glendale', 6500, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('glendale2', 'glendale2', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('gp1', 'gp1', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Grabger', 'granger', 50000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Gresley', 'gresley', 47500, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('GT 500', 'gt500', 785000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Guardian', 'guardian', 450000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('habanero', 'habanero', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hakuchou', 'hakuchou', 31000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hakuchou Sport', 'hakuchou2', 55000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('hellion', 'hellion', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hermes', 'hermes', 535000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hexer', 'hexer', 12000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hotknife', 'hotknife', 125000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('hotring', 'hotring', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Huntley S', 'huntley', 40000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Hustler', 'hustler', 625000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('imorgon', 'imorgon', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('impaler', 'impaler', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Infernus', 'infernus', 180000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('infernus2', 'infernus2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ingot', 'ingot', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Innovation', 'innovation', 23500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Intruder', 'intruder', 7500, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Issi', 'issi2', 10000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('issi3', 'issi3', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('issi7', 'issi7', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('italigtb', 'italigtb', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('italigtb2', 'italigtb2', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('italigto', 'italigto', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('italirsx', 'italirsx', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Jackal', 'jackal', 38000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Jester', 'jester', 65000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Jester(Racecar)', 'jester2', 135000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('jester3', 'jester3', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Journey', 'journey', 6500, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('jugular', 'jugular', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('kalahari', 'kalahari', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Kamacho', 'kamacho', 345000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('kanjo', 'kanjo', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Khamelion', 'khamelion', 38000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('komoda', 'komoda', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('krieger', 'krieger', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Kuruma', 'kuruma', 30000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Landstalker', 'landstalker', 35000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('landstalker2', 'landstalker2', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('RE-7B', 'le7b', 325000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('locust', 'locust', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Lynx', 'lynx', 40000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Mamba', 'mamba', 70000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Manana', 'manana', 12800, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('manana2', 'manana2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Manchez', 'manchez', 5300, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Manchez2', 'manchez2', 5300, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Massacro', 'massacro', 65000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Massacro(Racecar)', 'massacro2', 130000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Mesa', 'mesa', 16000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Mesa Trail', 'mesa3', 40000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('michelli', 'michelli', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Minivan', 'minivan', 13000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('minivan2', 'minivan2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Monroe', 'monroe', 55000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Moonbeam', 'moonbeam', 18000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Moonbeam Rider', 'moonbeam2', 35000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('nebula', 'nebula', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Nemesis', 'nemesis', 5800, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Neon', 'neon', 1500000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('nero', 'nero', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('nero2', 'nero2', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Nightblade', 'nightblade', 35000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Nightshade', 'nightshade', 65000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('9F', 'ninef', 65000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('9F Cabrio', 'ninef2', 80000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('novak', 'novak', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Omnis', 'omnis', 35000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('oracle', 'oracle', 45000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Oracle XS', 'oracle2', 35000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Osiris', 'osiris', 160000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('outlaw', 'outlaw', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Panto', 'panto', 10000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Paradise', 'paradise', 19000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('paragon', 'paragon', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Pariah', 'pariah', 1420000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Patriot', 'patriot', 55000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('patriot2', 'patriot2', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('PCJ-600', 'pcj', 6200, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('penetrator', 'penetrator', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Penumbra', 'penumbra', 28000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('penumbra2', 'penumbra2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('peyote', 'peyote', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('peyote2', 'peyote2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('peyote3', 'peyote3', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Pfister', 'pfister811', 85000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Phoenix', 'phoenix', 12500, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Picador', 'picador', 18000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Pigalle', 'pigalle', 20000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('pony', 'pony', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('pony2', 'pony2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Prairie', 'prairie', 12000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Premier', 'premier', 8000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('primo', 'primo', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Primo Custom', 'primo2', 14000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('X80 Proto', 'prototipo', 2500000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Radius', 'radi', 29000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('raiden', 'raiden', 1375000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rancherxl', 'rancherxl', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rapid GT', 'rapidgt', 35000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rapid GT Convertible', 'rapidgt2', 45000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rapid GT3', 'rapidgt3', 885000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('raptor', 'raptor', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ratbike', 'ratbike', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ratloader', 'ratloader', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ratloader2', 'ratloader2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Reaper', 'reaper', 150000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rebel', 'rebel', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rebel', 'rebel2', 35000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rebla', 'rebla', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Regina', 'regina', 5000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Retinue', 'retinue', 615000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('retinue2', 'retinue2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Revolter', 'revolter', 1610000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rhapsody', 'rhapsody', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('riata', 'riata', 380000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rocoto', 'rocoto', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Ruffian', 'ruffian', 6800, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ruiner', 'ruiner', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ruiner3', 'ruiner3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Rumpo', 'rumpo', 15000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rumpo2', 'rumpo2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ruston', 'ruston', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('s80', 's80', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sabre Turbo', 'sabregt', 20000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sabre GT', 'sabregt2', 25000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sanchez', 'sanchez', 5300, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sanchez Sport', 'sanchez2', 5300, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sanctus', 'sanctus', 25000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sandking', 'sandking', 55000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('sandking2', 'sandking2', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Savestra', 'savestra', 990000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('SC 1', 'sc1', 1603000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Schafter', 'schafter2', 25000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Schafter V12', 'schafter3', 50000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('schafter4', 'schafter4', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('schlagen', 'schlagen', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('schwarzer', 'schwarzer', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Scorcher', 'scorcher', 280, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Seminole', 'seminole', 25000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('seminole2', 'seminole2', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sentinel', 'sentinel', 32000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sentinel XS', 'sentinel2', 40000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sentinel3', 'sentinel3', 650000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('serrano', 'serrano', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Seven 70', 'seven70', 39500, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('ETR1', 'sheava', 220000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Slam Van', 'slamvan3', 11500, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sovereign', 'sovereign', 22000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('specter', 'specter', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('specter2', 'specter2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('speedo', 'speedo', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('speedo2', 'speedo2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('speedo4', 'speedo4', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('squaddie', 'squaddie', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('stafford', 'stafford', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('stalion', 'stalion', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Stalion2', 'stalion2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('stanier', 'stanier', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Stinger', 'stinger', 80000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Stinger GT', 'stingergt', 75000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('stratum', 'stratum', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Streiter', 'streiter', 500000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Stretch', 'stretch', 90000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('stryder', 'stryder', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('sugoi', 'sugoi', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sultan', 'sultan', 15000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('sultan2', 'sultan2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Sultan RS', 'sultanrs', 65000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Super Diamond', 'superd', 130000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Surano', 'surano', 50000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Surfer', 'surfer', 12000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('surfer2', 'surfer2', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('surge', 'surge', 45000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('swinger', 'swinger', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('T20', 't20', 300000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('taco', 'taco', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tailgater', 'tailgater', 30000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('taipan', 'taipan', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tampa', 'tampa', 16000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Drift Tampa', 'tampa2', 80000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tempesta', 'tempesta', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tezeract', 'tezeract', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('thrax', 'thrax', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Thrust', 'thrust', 24000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tigon', 'tigon', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('torero', 'torero', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado', 'tornado', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado2', 'tornado2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado3', 'tornado3', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado4', 'tornado4', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado5', 'tornado5', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tornado6', 'tornado6', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('toros', 'toros', 45000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tri bike', 'tribike', 520, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tri bike', 'tribike2', 520, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tri bike', 'tribike3', 520, 'cycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Trophy Truck', 'trophytruck', 60000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Trophy Truck Limited', 'trophytruck2', 80000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tropos', 'tropos', 40000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tulip', 'tulip', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('turismo2', 'turismo2', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Turismo R', 'turismor', 350000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tyrant', 'tyrant', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Tyrus', 'tyrus', 600000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Vacca', 'vacca', 120000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Vader', 'vader', 7200, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vagner', 'vagner', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vagrant', 'vagrant', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vamos', 'vamos', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Verlierer', 'verlierer2', 70000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('verus', 'verus', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Vigero', 'vigero', 12500, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vindicator', 'vindicator', 45000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Virgo', 'virgo', 14000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('virgo2', 'virgo2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('virgo3', 'virgo3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Viseris', 'viseris', 875000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Visione', 'visione', 2250000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Voltic', 'voltic', 90000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Voodoo', 'voodoo', 7200, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('voodoo2', 'voodoo2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Vortex', 'vortex', 9800, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vstr', 'vstr', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Warrener', 'warrener', 4000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Washington', 'washington', 9000, 'sedans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('weevil', 'weevil', 8000, 'compacts'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Windsor', 'windsor', 95000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Windsor Drop', 'windsor2', 125000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('winky', 'winky', 45000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Woflsbane', 'wolfsbane', 9000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('xa21', 'xa21', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('XLS', 'xls', 32000, 'suvs'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Yosemite', 'yosemite', 485000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('yosemite2', 'yosemite2', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('yosemite3', 'yosemite3', 45000, 'muscle'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Youga', 'youga', 10800, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Youga Luxuary', 'youga2', 14500, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('youga3', 'youga3', 20000, 'vans'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Z190', 'z190', 900000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Zentorno', 'zentorno', 1500000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Zion', 'zion', 36000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Zion Cabrio', 'zion2', 45000, 'coupes'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('zion3', 'zion3', 20000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Zombie', 'zombiea', 9500, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Zombie Luxuary', 'zombieb', 12000, 'motorcycles'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('zorrusso', 'zorrusso', 20000, 'super'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('caracara2', 'caracara2', 20000, 'offroad'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('Z-Type', 'ztype', 220000, 'sportsclassics'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('comet6', 'comet6', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dominator7', 'dominator7', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('dominator8', 'dominator8', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('euros', 'euros', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('futo2', 'futo2', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('rt3000', 'rt3000', 2000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('sultan3', 'sultan3', 2000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('tailgater2', 'tailgater2', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('growler', 'growler', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('vectre', 'vectre', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('remus', 'remus', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('calico', 'calico', 2000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('cypher', 'cypher', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('jester4', 'jester4', 2000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('zr350', 'zr350', 2000, 'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('previon', 'previon', 2000 ,'sports'); 
REPLACE  INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES 
	('warrener2', 'warrener2', 20000, 'sports');
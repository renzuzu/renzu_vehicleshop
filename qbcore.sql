ALTER TABLE player_vehicles
ADD `type` varchar(32) NOT NULL DEFAULT 'car';

ALTER TABLE player_vehicles
ADD `job` varchar(32) NOT NULL DEFAULT 'civ';
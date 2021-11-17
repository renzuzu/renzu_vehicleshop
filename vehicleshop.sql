--ADD or IMPORT TABLE and Columns only if its not existed yet on your Database!

-- ADD ONE BY ONE to avoid issue

-- DO NOT COPY THIS MESSAGE and paste to the SQL QUERY Import

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

ALTER TABLE owned_vehicles
ADD `garage_id` varchar(32) NOT NULL DEFAULT 'A';


ALTER TABLE owned_vehicles
ADD job varchar(32) NOT NULL DEFAULT 'civ';

ALTER TABLE owned_vehicles
ADD `stored` varchar(32) NOT NULL DEFAULT 1;
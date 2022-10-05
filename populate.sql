--
CREATE DATABASE chessdb;
--
SHOW DATABASES;
--
USE chessdb;
-- fix 1364 MYSQL error
SET GLOBAL sql_mode='';
-- create main table
CREATE TABLE games
(
	id	INT unsigned NOT NULL AUTO_INCREMENT,
	result 	VARCHAR(8) NOT NULL DEFAULT "",
	id_white	INT unsigned NOT NULL,
	id_black	INT unsigned NOT NULL,
	moves	VARCHAR(10000) NOT NULL DEFAULT "",
	PRIMARY KEY (id)
);
---
CREATE TABLE ids
(
	id INT unsigned NOT NULL AUTO_INCREMENT,
	user VARCHAR(20) NOT NULL DEFAULT "",
	PRIMARY KEY (id)
);
---
LOAD DATA INFILE 'IDs.txt'
INTO TABLE ids
FIELDS TERMINATED BY '\n'
(user);
--
DESCRIBE games;
DESCRIBE ids;
-- utilizzo arch linux, ho dovuto copiare i file creati dallo script shell su /var/lib/mysql/chessdb come root
CREATE TABLE import_result ( results VARCHAR(8) NOT NULL DEFAULT "" );
CREATE TABLE import_white ( white VARCHAR(20) NOT NULL DEFAULT "" );
CREATE TABLE import_black ( black VARCHAR(20) NOT NULL DEFAULT "" );
CREATE TABLE import_moves ( moves VARCHAR(10000) NOT NULL DEFAULT "" );
--
SHOW TABLES;
-- importing all data
LOAD DATA INFILE 'results.txt'
INTO TABLE import_result
FIELDS TERMINATED BY '\n'
LINES TERMINATED BY '\n';
--
LOAD DATA INFILE 'white.txt'
INTO TABLE import_white
FIELDS TERMINATED BY '\n'
LINES TERMINATED BY '\n';
--
LOAD DATA INFILE 'black.txt'
INTO TABLE import_black
FIELDS TERMINATED BY '\n'
LINES TERMINATED BY '\n';
--
LOAD DATA INFILE 'moves.txt'
INTO TABLE import_moves
FIELDS TERMINATED BY '\n'
LINES TERMINATED BY '\n';
-- copying data into the main table
-- non so perché ma quando faccio una query senza specificare WHERE mi dà risultato nullo... ma poi se cerco un dato particolare mi offre risultati
INSERT INTO games (result) SELECT * FROM import_result;

INSERT INTO games (id_white) SELECT ids.id FROM ids, games WHERE ;

INSERT INTO games (id_black) SELECT * FROM import_black;


INSERT INTO games (moves) SELECT * FROM import_moves;
-- deleting import tables
DROP TABLE import_result;
DROP TABLE import_white;
DROP TABLE import_black;
DROP TABLE import_moves;

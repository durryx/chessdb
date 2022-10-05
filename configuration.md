# Configuration Steps

1. Install and setup mysql

Install the DB <br>
Arch: `sudo pacman -S mariadb mariadb-clients mariadb-libs mysql` <br>
Ubuntu: `sudo apt install mysql-server` <br>
Local installation <br>
`sudo mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/` <br>
Fix eventual "Permission denied" errors
```
$ sudo chown -R mysql:mysql /var/lib/mysql/
$ chmod -R 755 /var/lib/mysql/
```
Start the service (each reboot) <br>
`sudo systemctl start mysqld` <br>
Install MySQL workbentch <br>
Arch: `sudo pacman -S mysql-workbench` <br>
Ubuntu: `sudo apt install mysql-workbench` <br>

2. Import

Download the compresseed .pgn files of the best lichess.com games from https://database.nikonoel.fr/ <br>
Extract the files and run the script
```
$ mkdir lichess_dump
$ 7z e "Lichess Elite Database.7z" -olichess_dump
$ cd lichess_dump
$ sh ../extract.sh
creating IDs table from all .pgn files
processing lichess_elite_2013-09.pgn
done
...
done with MOVES
done with RESULTS
done with BLACK
done with WHITE
added lichess_elite_2020-05.pgn to all tables
$
```

Start MySQL and create database
```
$ sudo mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 10
Server version: 10.9.3-MariaDB Arch Linux

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE DATABASE chessdb;
```

Copy the newly generated files into the DB destination
```
$ sudo cp black.txt IDs.txt moves.txt results.txt white.txt /var/lib/mysql/chessdb/
```
Run the SQL script (may take a while)
```
MariaDB [(none)]> source /home/gio/code/chess_database/populate.sql
```

3. Query test

Test the DB with some queries
```
MariaDB [(none)]> DESCRIBE games;
MariaDB [(none)]> DESCRIBE ids;
MariaDB [(none)]> SELECT * FROM ids WHERE user="rabbit-a";
MariaDB [(none)]> SELECT * FROM games LIMIT 0, 10;
```


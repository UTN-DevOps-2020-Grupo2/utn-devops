-- create the databases
CREATE DATABASE IF NOT EXISTS dbname;
USE dbname;
CREATE TABLE employees (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100) NOT NULL, address VARCHAR(255) NOT NULL, salary INT(10) NOT NULL );
DROP DATABASE IF EXISTS testdb;
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

DROP TABLE IF EXISTS test_insert_src;
CREATE TABLE test_insert_src (
    id SERIAL PRIMARY KEY,
    name TEXT
) engine=InnoDB;

DROP TABLE IF EXISTS test_insert_no_index;
CREATE TABLE test_insert_no_index (
    id SERIAL PRIMARY KEY,
    name TEXT
) engine=InnoDB;

DROP TABLE IF EXISTS test_insert_normal_index;
CREATE TABLE test_insert_normal_index (
    id SERIAL PRIMARY KEY,
    name TEXT,
    INDEX name_index (name(32))
) engine=InnoDB;

DROP PROCEDURE IF EXISTS test_insert_proc_batch_bulk;
DELIMITER //
CREATE PROCEDURE test_insert_proc_batch_bulk(IN name TEXT, IN fromNum INT, IN toNum INT)
BEGIN
    DECLARE i INT DEFAULT fromNum;
    DECLARE new_names TEXT DEFAULT '';
    SET @sql = 'INSERT INTO test_insert_src (name) VALUES ';
    WHILE i < toNum DO
        SET new_names = CONCAT(name, i);
        SET i = i + 1;
        SET @sql = CONCAT(@sql, '("', new_names, '"),');
    END WHILE;
    SET @sql = LEFT(@sql, LENGTH(@sql) - 1);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS test_insert_proc_batch;
DELIMITER //
CREATE PROCEDURE test_insert_proc_batch(IN name TEXT, IN count INT, IN step INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < count DO
        CALL test_insert_proc_batch_bulk(name, i, i + step);
        SET i = i + step;
    END WHILE;
    COMMIT;
END //
DELIMITER ;

CALL test_insert_proc_batch('test', 10000000, 5000);

TRUNCATE TABLE test_insert_no_index;
INSERT INTO test_insert_no_index SELECT * FROM test_insert_src;

TRUNCATE TABLE test_insert_normal_index;
INSERT INTO test_insert_normal_index SELECT * FROM test_insert_src;

SET @not_exist_name = 'not_exist';
SELECT * FROM test_insert_no_index WHERE name = @not_exist_name;
SELECT * FROM test_insert_normal_index WHERE name = @not_exist_name;

SET @exist_name_9999 = 'test9999';
SELECT * FROM test_insert_no_index WHERE name = @exist_name_9999;
SELECT * FROM test_insert_normal_index WHERE name = @exist_name_9999;

SET @exist_name_99999 = 'test99999';
SELECT * FROM test_insert_no_index WHERE name = @exist_name_99999;
SELECT * FROM test_insert_normal_index WHERE name = @exist_name_99999;

SET @exist_name_999999 = 'test999999';
SELECT * FROM test_insert_no_index WHERE name = @exist_name_999999;
SELECT * FROM test_insert_normal_index WHERE name = @exist_name_999999;

SET @exist_name_9999999 = 'test9999999';
SELECT * FROM test_insert_no_index WHERE name = @exist_name_9999999;
SELECT * FROM test_insert_normal_index WHERE name = @exist_name_9999999;
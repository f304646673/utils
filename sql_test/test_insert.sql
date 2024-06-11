-- 无索引的表。逐条插入和批量插入的性能对比。
DROP DATABASE IF EXISTS testdb;
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

DROP TABLE IF EXISTS test_insert;
CREATE TABLE test_insert (
    id SERIAL PRIMARY KEY,
    name TEXT
) engine=InnoDB;

DROP PROCEDURE IF EXISTS test_insert_proc_batch;
DELIMITER //
CREATE PROCEDURE test_insert_proc_batch(IN name TEXT, IN count INT)
BEGIN
    DECLARE i INT DEFAULT 0;
		DECLARE new_name TEXT DEFAULT '';
    WHILE i < count DO
        SET new_name = CONCAT(name, i);
        INSERT INTO test_insert (name) VALUES (new_name);
        SET i = i + 1;
    END WHILE;
    COMMIT;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS test_insert_proc_batch_bulk;
DELIMITER //
CREATE PROCEDURE test_insert_proc_batch_bulk(IN name TEXT, IN count INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE new_names TEXT DEFAULT '';
    SET @sql = 'INSERT INTO test_insert (name) VALUES ';
    WHILE i < count DO
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

TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 1000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 2000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 3000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 4000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 5000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 6000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 7000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 8000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 9000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 10000);


TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 10000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 20000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 30000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 40000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 50000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 60000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 70000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 80000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 90000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch_bulk('test', 100000);

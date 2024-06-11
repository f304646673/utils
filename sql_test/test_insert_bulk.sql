-- 无索引的表。批量插入的性能对比，主要对比每批插入的数据数量区别。
DROP DATABASE IF EXISTS testdb;
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

DROP TABLE IF EXISTS test_insert;
CREATE TABLE test_insert (
    id SERIAL PRIMARY KEY,
    name TEXT
) engine=InnoDB;

DROP PROCEDURE IF EXISTS test_insert_proc_batch_bulk;
DELIMITER //
CREATE PROCEDURE test_insert_proc_batch_bulk(IN name TEXT, IN fromNum INT, IN toNum INT)
BEGIN
    DECLARE i INT DEFAULT fromNum;
    DECLARE new_names TEXT DEFAULT '';
    SET @sql = 'INSERT INTO test_insert (name) VALUES ';
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
    DECLARE new_name TEXT DEFAULT '';
    WHILE i < count DO
        SET new_name = CONCAT(name, i);
        CALL test_insert_proc_batch_bulk(new_name, i, i + step);
        SET i = i + step;
    END WHILE;
    COMMIT;
END //
DELIMITER ;

TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 50);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 100);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 150);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 200);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 250);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 300);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 350);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 400);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 450);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 1000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 1500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 2000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 2500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 5000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 7500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 10000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 12500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 15000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 17500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 20000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 22500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 25000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 27500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 30000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 32500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 35000);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 37500);
TRUNCATE TABLE test_insert;
CALL test_insert_proc_batch('test', 100000, 40000);
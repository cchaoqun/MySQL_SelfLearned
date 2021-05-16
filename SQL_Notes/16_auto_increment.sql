#标识列
/*
又称自增长列
含义: 可以不用手动插入值,系统提供默认的序列值

特点:
1.标识列不一定与主键搭配, 但要求一定是一个key
2.一个表可以有几个标识列,至多一个
3.标识列的类型: 只能是数值型
4.标识列可以通过 SET auto_increment_increment = 3 设置步长
*/
#一 ============创建表时设置表示列===========
USE students;
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity(
		id INT ,
		id2 INT UNIQUE ,
		NAME VARCHAR(20),
		salary FLOAT UNIQUE 

);
TRUNCATE TABLE tab_identity;
SHOW INDEX FROM tab_identity;
DESC tab_identity;
#更改起始值, 无法手动更改, 可以第一次插入使用需要的起始值, 后面全部用NULL,就会从输入起始值后增加
INSERT INTO tab_identity(id, NAME) VALUES(NULL, 'john');
INSERT INTO tab_identity(NAME) VALUES('lily');
SELECT * FROM tab_identity;

SHOW VARIABLES LIKE "%auto_increment%";
SET auto_increment_increment = 1;

#二 ===========修改表时设置标识列===========
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

#三============修改表时删除标识列===========
ALTER TABLE tab_identity MODIFY COLUMN id INT;



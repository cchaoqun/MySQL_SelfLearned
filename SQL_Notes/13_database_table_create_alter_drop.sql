#DDL
/*
数据定义语言
库和表的管理
一 库的管理
创建 修改 删除
二 表的管理
创建 修改 删除

创建: create
修改: alter  (修改结构)
删除: drop (删除后表不存在)

*/

#一 ==============库的管理===================
#1. 库的创建
/*
语法
create database (if not exist)库名;


*/
#案例;创建库
CREATE DATABASE IF NOT EXISTS books;

#2.库的修改
#不安全 已经弃用
RENAME DATABASE books TO '新库名';
#更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;

#3. 库的删除
DROP DATABASE IF EXISTS books;


#二======表的管理=============
#1. 表的管理
/*

CREATE TABLE 表名(
		列名 列的类型 [(长度) 约束],
		列名 列的类型 [(长度) 约束],
		列名 列的类型 [(长度) 约束],
		列名 列的类型 [(长度) 约束],
		...
		列名 列的类型 [(长度) 约束]

)
*/

CREATE TABLE IF NOT EXISTS book(
		id INT, #编号
		bName VARCHAR(20), #20代表字段最大长度
		price DOUBLE, #价格
		authorId INT, #作者编号
		publishDate DATETIME#出版日期
);

DESC book;

#案例L创建表author
CREATE TABLE IF NOT EXISTS author(
		id INT,
		au_name VARCHAR(20),
		nation VARCHAR(10)
);

#2.表的修改
/*
ALTER TABLE 表名 ADD|DROP|MODIFY|CHANGE COLUMN 列名 [列类型,约束]
*/
DESC book;
DESC book_author;
#1.修改列名
ALTER TABLE book CHANGE COLUMN publishDate pubDate DATETIME;

#2.修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;

#3,添加列
ALTER TABLE author ADD COLUMN annual DOUBLE;
/*
ALTER TABLE 表名 ADD  COLUMN 字段名 类型 [first|after 字段名];
*/
CREATE TABLE test_add_column(
		t1 INT,
		t2 INT,
		t3 INT

);
ALTER TABLE test_add_column ADD COLUMN newT1 INT FIRST;
ALTER TABLE test_add_column ADD COLUMN newT2 INT AFTER t1;



#4.删除列
ALTER TABLE author DROP COLUMN annual;

#5.修改表名
ALTER TABLE author RENAME TO book_author;



#3.表的删除
# IF EXISTS 只用于库和表的删除创建 不适用与列
DROP TABLE IF EXISTS book_author;

#查看当前库的所有表
SHOW TABLES;

#通用的写法:
/*
DROP dATABASE IF EXISTS 旧库名;
CREATE DATABASE 新库名;

DROP table IF EXISTS 旧库名;
CREATE table 新表名();
*/

#4.表的复制
INSERT INTO author VALUES
(1,'村上村树', '日本'),
(1,'莫言', '中国'),
(3,'冯唐', '中国'),
(4,'金庸','中国');

SELECT * FROM author;
SELECT * FROM copy;
SELECT * FROM copy2;
SELECT * FROM copy3;
SELECT * FROM copy4;
#1.仅复制表的结构
CREATE TABLE copy LIKE author;
#2.复制表的结构+值
CREATE TABLE copy2
SELECT * FROM author;
#3.只赋值部分数据
CREATE TABLE copy3
SELECT * FROM author WHERE nation="中国";
#4.仅仅复制某些字段
CREATE TABLE IF NOT EXISTS copy4
SELECT id, au_name
FROM author
WHERE 0;

CREATE DATABASE IF NOT EXISTS TEST;
#============Prac==============
#1. 
USE TEST;
DROP TABLE dept1;
CREATE TABLE dept1(
		id INT(7),
		NAME VARCHAR(25)
);
#2.将表departments中的数据插入新表dept2中
CREATE TABLE dept2
SELECT department_id, department_name FROM myemployees.departments;
SELECT * FROM dept2;

#3.
CREATE TABLE emp5(
		id INT(7),
		First_name VARCHAR(25),
		Last_name VARCHAR(25),
		Dept_id INT(7)
);
#4. last_name长度修改为50
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);
DESC emp5;

#5. 根据employees创建employees2
CREATE TABLE employees2 LIKE myemployees.employees;
DESC employees2;

#6.删除表emp5
DROP TABLE IF EXISTS emp5;

#7.将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5;

#8在表emp5 dept中添加新列test_column 
ALTER TABLE emp5 ADD COLUMN test_column VARCHAR(20);
ALTER TABLE dept1 ADD COLUMN test_column VARCHAR(20);
DESC emp5;
DESC dept1;

#9.直接删除表emp5中的列 dept_id
ALTER TABLE emp5 DROP COLUMN test_column;


















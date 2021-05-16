#DML 语言
/*
数据操作语言
插入: insert
修改: update
删除: delete

*/

#一 =============插入语句===============
#方式一: 经典的插入
/*
语法:
insert into 表名 (列名,...) values (值1,...);

*/
SELECT * FROM beauty;
#1.插入的值的类型要与列的类型一致或兼容
INSERT INTO beauty(id, NAME, sex, borndate, phone, photo, boyfriend_id)
VALUES(13,'唐艺昕', '女', '1990-4-23', '18999999', NULL, 2);

#2.不可以为null的列必须插入值 可以为null的列如何插入值?
#方式一: 列名不省略,值=null
INSERT INTO beauty(id, NAME, sex, borndate, phone, photo, boyfriend_id)
VALUES(13,'唐艺昕', '女', '1990-4-23', '18999999', NULL, 2);
#方式二: 列名和值都省略
INSERT INTO beauty(id, NAME, sex,phone)
VALUES(15,'娜扎', '女' ,'19989999');

#3.列顺序是否可以调换
INSERT INTO beauty(NAME, sex, id, phone)
VALUES('girls', '女', 16, '18882');

#4.列数和值的个数必须一致
INSERT INTO beauty(NAME, sex, id, phone)
VALUES('关晓彤', '女', 17, '18882');

#5.可以省略列名,默认所有列,而且列的顺序和表中顺序一致
INSERT INTO beauty
VALUES (18, '张飞', '男', NULL, '119', NULL, NULL);

#方式二:
/*
语法
INSERT INTO 表名
SET 列名=值,列名=值,...

*/
INSERT INTO beauty
SET id=19, NAME='girls3', phone='999';

SELECT  * FROM beauty;
#两种方式比较
#1.方式一支持插入多行 方式二不支持
INSERT INTO beauty
VALUES(23,'唐艺昕1', '女', '1990-4-23', '18999999', NULL, 2)
,(24,'唐艺昕2', '女', '1990-4-23', '18999999', NULL, 2)
,(25,'唐艺昕3', '女', '1990-4-23', '18999999', NULL, 2);

#2,方式一支持子查询, 方式二不支持
INSERT INTO beauty(id, NAME, phone)
SELECT 26,'宋茜', '110';

INSERT INTO beauty(id, NAME, phone)
SELECT id, boyname,'123'
FROM boys WHERE id<3;

#二 修改语句
/*
1.修改单表的记录
语法:
update 表名
set 列=新值,列=新值,...
WHERE 筛选条件;

2.修改多表的记录 
语法:
sql92语法
update 表1 别名, 表2 别名
SET 列=值,...
WHERE 筛选条件
AND 筛选条件

sql99语法:
update 表1 别名
inner|left|right join 表2 别名
on 连接条件
set 列=值,...
where 筛选条件;
*/
SELECT * FROM beauty;
SELECT * FROM boys;
#1.修改单表的记录
 #案例1: 修改beauty中姓唐的人电话变成138
 UPDATE beauty
 SET phone='138xxxxxx'
 WHERE NAME LIKE '唐%';

#案例2: 修改boys表中id为2的名称为张飞, userCP = 10
UPDATE boys
SET boyname = '张飞', userCP  = 10
WHERE id = 2;

#2.修改多表的记录
#案例1: 修改张无忌的女朋友的电话为114
UPDATE boys b
INNER  JOIN beauty be
ON b.id = be.`boyfriend_id`
SET be.phone = '114'
WHERE b.boyname = '张无忌';

#案例2: 修改没有男朋友的女神的男朋友编号为2
UPDATE beauty be
LEFT JOIN boys bo ON be.`boyfriend_id` = bo.`id`
SET be.boyfriend_id = 10
WHERE bo.id IS NULL;


SELECT * FROM beauty;

#三============删除语句==============
/*
方式一: delete
语法:
1.单表的删除
delete from 表名 where 筛选条件 LIMIT 条目数
2.多表的删除
sql92语法
delete 表1的别名,表2的别名
from 表1 别名, 表2 别名
where 连接条件
and 筛选条件;

sql99
delete 表1的别名,表2的别名
from 表1 别名
inner|left|right join  表2 别名 on 连接条件
where 筛选条件

方式二:truncate
语法: truncate table 表名 //删除整个表,不能加筛选条件

*/
USE girls;
SELECT * FROM boys;
SELECT * FROM beauty;
#方式一: delete
#1. 单表的删除
#案例1: 删除手机号以9结尾的女神信息
DELETE FROM beauty WHERE phone LIKE "%9";
DELETE FROM beauty WHERE id=25 OR id=26 LIMIT 1;
#2.多表的删除

#案例: 删除张无忌的女朋友的信息
DELETE be
FROM beauty be
INNER JOIN boys bo 
ON be.boyfriend_id = bo.id
WHERE bo.boyName = "张无忌";

#案例: 删除黄晓明的信息以及女朋友的信息
DELETE be, bo
FROM boys bo
INNER JOIN beauty be 
ON bo.id = be.`boyfriend_id`
WHERE bo.boyName = "黄晓明";

#方式二: truncate 语句
#案例: 将魅力值>100的男神信息删除
#不能加筛选条件,只能整个表
TRUNCATE TABLE boys;

#delete VS truncate
/*
1.delete可以加where 条件, truncate不能加
2.truncate 删除,效率高一点
3.假如要删除的表中有自增长列, 如果用delete删除后,再插入数据从自增长列开始
truncate删除后,在插入数据,自增长列从1开始 (例如id列)
4.truncate删除没有返回值, delete删除有返回值
5.truncate 删除不能回滚, delete删除可以回滚
*/
DELETE FROM boys;
TRUNCATE TABLE boys;
SELECT * FROM boys;
INSERT INTO boys(boyName, userCP)
VALUES('张飞',100), ('张飞1',100), ('张飞2',100);

#练习
#1.创建表
USE myemployees;
CREATE TABLE my_employees(
		Id INT(10),
		First_name VARCHAR(10),
		Last_name VARCHAR(10),
		Userid VARCHAR(10),
		Salary DOUBLE (10,2)
);

CREATE TABLE users(
		id INT,
		userid VARCHAR(10),
		department_id INT
);
#2.显示表的结构
DESC my_employees;

#3. 插入数据
#方式一
INSERT  INTO my_employees
VALUES(1,'Patel', 'Ralph', 'Rpatel', 895)
,(2,'Dancs','Betty','Bdancs',860)
,(3,'Biri','Ben','Bbiri',1100)
,(4,'Newman','Chad','Newman',750)
,(5,'Ropeburn','Audrey','Aropebur',1550);
DELETE FROM my_employees;
#方式二
INSERT INTO my_employees
SELECT 1,'Patel', 'Ralph', 'Rpatel', 895 UNION
SELECT 2,'Dancs','Betty','Bdancs',860 UNION
SELECT 3,'Biri','Ben','Bbiri',1100 UNION
SELECT 4,'Newman','Chad','Newman',750 UNION
SELECT 5,'Ropeburn','Audrey','Aropebur',1550 ;

#4. 插入users
INSERT INTO users
VALUES(1,'Rpatel',10),(2,'Bdancs',10),(3,'Bbiri',20),(4,'Cnewman',30),(5,'Aropebur',40);

SELECT * FROM users;
SELECT * FROM my_employees;

#5.将3号员工的last_name修改为 "drelxer";
UPDATE my_employees
SET last_name="drexler"
WHERE Id = 3;

#6. 将所有工资<900的员工修改为1000
UPDATE my_employees
SET salary=1000
WHERE salary<900;

#7将userid为Bbiri的user表和my_employees表的记录全部删除
DELETE u, m
FROM users u
INNER JOIN my_employees m ON m.Userid = u.userid
WHERE u.userid = "Bbiri";

#8.删除所有数据
DELETE FROM my_employees;
DELETE FROM users;

#9.检查所做的修正
SELECT * FROM users;
SELECT * FROM my_employees;
#清空表my_employees
TRUNCATE TABLE users;
TRUNCATE TABLE my_employees;


















#TCL
/*
Transaction Control Language: 事务控制语言
事务:
一个或一组sql语句组成一个执行单元,要么全部执行,要么全部不执行

案例: 转账
a 1000
b 1000

update 表 set a的余额=500 where name = a
意外
update 表 set b的余额=1500 where name = b

事务的特性 ACID
原子性: 一个事务不可再分割,要么都执行,要么都不执行
一致性: 一个事务会使数据从一个一直的状态切换到另一个一直的状态
隔离性:  一个事务的执行不受其他事务的干扰 取决于隔离级别
持久性: 一个事务一旦提交,则会永久的改变数据库的数据

事务的创建
隐式事务: 事务没有明显的开启和结束的标记
		比如: insert update delete 语句
		
显示事务: 事务具有明显的开启和结束的标记
前提: 必须先设置自动提交功能为禁用
set autocommit = 0;
步骤1: 开启事务
	set autocommit = 0;
	start transaction; 可选的
步骤2: 编写事务中的sql语句(select insert update delete)
	语句1;
	语句2;
	...
步骤3:结束事务
	commit; 提交事务
	rollback; 回滚事务
	
	
savepoint 节点名; 设置保存点

事务的隔离级别:
read uncommited:  
	出现脏读,不可重复度,幻读
		脏读:
			线程2更新数据未提交,
			线程1读, 显示了线程2更新未提交的临时数据
			线程2rollback
			线程1再读,读到了线程2回滚后的初始数据
			第一次读到的数据为无效的临时数据
		不可重复读:
			线程1读,
			线程2更新数据提交了
			线程1再读,两次读取的数据不同
		幻读:
			线程1读
			线程2插入了一行并提交
			线程1在读,发现多了一行
			两次读到的数据量不同
read commited:
	避免脏读, 出现不可重复读和幻读
	不会读到未提交的临时数据所以可以避免幻读
	但是对于两次读取之间其他线程提交的更新的或者插入的数据,无法避免,造成了不可重复读和幻读
repeatable read:
	避免脏读,不可重复读,但是无法避免幻读
	当前线程不会读取其他线程提交的或者未提交的更新数据,避免了脏读和不可重复读
	但是对于其他线程提交的插入数据不可避免,所以还是会出现幻读
serializable:
	避免所有的并发问题
	一个线程使用时,其他线程无法对表进行修改操作,相当于上了锁,任何的更新操作都需要等待
	当前线程结束释放锁以后才能访问到当前表
				脏读	不可重复读	幻读
read uncommited	√		√			√
read commited		×		√			√
repeatable  read		×		×			√
serializable		×		×			×

mysql默认 repeatable read 隔离级别
oracle默认 read commited
#查看隔离级别
select @@transaction_isolation
#设置隔离级别
set session|global transaction isolation level 隔离级别



开启事务的语句;
update 表 set a的余额=500 where name = a

update 表 set b的余额=1500 where name = b
结束事务的语句


*/
SHOW ENGINES;

SHOW VARIABLES LIKE "autocommit";


DROP TABLE IF EXISTS account;
CREATE TABLE account(
		id INT PRIMARY KEY AUTO_INCREMENT,
		username VARCHAR(20),
		balance DOUBLE
);
INSERT INTO account (username, balance)
VALUES( 'user1', 1000),('user2', 1000);
SELECT * FROM account;

#开启事务
SET autocommit = 0;
START TRANSACTION;
#事务语句 
UPDATE account SET balance = 1000 WHERE username = 'user1';
UPDATE account SET balance =1000 WHERE username = 'user2';
#结束事务
ROLLBACK;#回滚
#提交事务
COMMIT;

#3. 演示savepoint的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=7;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id =4;
ROLLBACK TO a; #回滚到保存点

SELECT * FROM account;

#2. delete 和 truncate 在事务使用时的区别
#演示delete 支持回滚
SET autocommit=0;
START TRANSACTION;
DELETE FROM account;
ROLLBACK;

#演示truncate 不支持回滚
SET autocommit=0;
START TRANSACTION
DELETE FROM account;
ROLLBACK;

#=========Prac============
#1.
DROP TABLE book;
CREATE TABLE IF NOT EXISTS book(
	bid INT PRIMARY KEY,
	bname VARCHAR(20) UNIQUE NOT NULL,
	price DOUBLE DEFAULT 10,
	btypeId INT,
	FOREIGN KEY (bTypeId) REFERENCES bookType(id)
);

CREATE TABLE bookType(
	id INT PRIMARY KEY,
	NAME VARCHAR(20)
);

#2.开启事务
SET autocommit=0;
START TRANSACTION;
INSERT INTO bookType VALUES(1,'comedy');
INSERT INTO book VALUES(1,'book1', NULL, 1);
COMMIT;

SELECT * FROM book;
DESC book;

INSERT INTO book VALUES(2,'book12', 101, 1);
#3.创建视图 实现查询价格大于100的书名和类型名
CREATE OR REPLACE VIEW myv1
AS
SELECT b.bname, bt.name
FROM book b
INNER JOIN bookType bt
ON b.btypeId = bt.id
WHERE b.price>100; 

SELECT * FROM myv1;

INSERT INTO book VALUES(4,'book2', 95, 1);
INSERT INTO book VALUES(3,'book3', 100, 1);
#4.修改视图 实现查询价格在90-120支架您的书名和价格
CREATE OR REPLACE VIEW myv1
AS
SELECT b.bname, b.price
FROM book b
WHERE b.price BETWEEN 90 AND 120;

#5.
DROP VIEW myv1;




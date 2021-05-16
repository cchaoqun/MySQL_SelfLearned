# 常见约束

/*

含义: 一种限制,用于限制表中的数据, 用于保证表中数据的准确和可靠性

分类: 六大约束
		NOT NULL: 非空,保证该字段的值不能为NULL
			比如: 姓名 学号等
		DEFAULT; 默认 保证该字段有默认值
			比如: 性别 
		PRIMARY KEY: 主键, 用于保证该字段具备唯一性并且非空
			比如: 学号,员工编号
		UNIQUE: 唯一, 保证该字段的值具有唯一性,可以为空
			比如: 座位号
		CHECK: 检查约束 (MySQL不支持)  性别: sex='male' or sex='female'
		FOREIGN KEY: 外键约束, 用于限制两个表的关系,保证该字段的值必须来自于主表关联列的值
			在从表添加外键约束,用于引用主表某列的值
			比如: 学生表的专业编号, 员工表的部门编号,工种编号
			
添加约束的时机:
			1. 创建表时
			2. 修改表时
			
约束的添加分类:
			列级约束:
				六大约束语法上都支持,但外键约束没有效果
			表级约束:
				除了非空,默认其他都支持
	

主键和唯一的对比:
			保证唯一性	是否允许为空 	一个表中可以有多少个	是否允许组合
	主键	√			×				至多一个				√ 但不推荐
	唯一	√			√				可以有多个				√ 但不推荐

外键
	1.要求在从表设置外键关系
	2.从表的外键列的类型和主表的关联列的类型要求一致或兼容,名称无要求
	3.主表的关联列必须是一个key, (一般是主键或唯一)
	4.插入数据时, 应该先插入主表数据 再插入从表数据
	   删除数据时, 先删除从表, 再删除主表
	
	INSERT INTO major values(1, 'java');
	INSERT INTO major values(2, 'h5');
	SELECT * FROM major;
	SELECT * FROM stuinfo;
	DELETE FROM stuinfo;
	INSERT INTO stuinfo values(1, 'john', '男', 1,19, 1,1);
	INSERT INTO stuinfo values(1, 'john', '男', 2,19, 2,2);
	
	DROP TABLE IF EXISTS stuinfo;
	DROP TABLE IF EXISTS major;
	CREATE TABLE major(
		id INT UNIQUE,
		majorName VARCHAR(20)
	);
	CREATE TABLE stuinfo(
		id INT,
		stuName VARCHAR(20), 
		gender CHAR(1),
		seat INT,
		age INT,
		majorId INT,
		seat2 INT,
		
		CONSTRAINT pk PRIMARY KEY(id, stuName),#主键
		CONSTRAINT uq UNIQUE(seat,seat2), #唯一键
		CONSTRAINT ck CHECK(gender='男' OR gender = '女'), #检查约束
		CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)#外键
	);
SHOW INDEX FROM stuinfo;

		
CREATE TABLE 表名(
	字段名 字段类型 列级约束
	字段名 字段类型,
	表级约束

)

*/

CREATE DATABASE students;
#一 ==============创建表时添加约束===============
#1. ----------------条件列级约束-----------------------
/*
语法:
	直接在字段名和类型后面追加 约束类型即可
	只支持: 默认 非空 主键 唯一



*/
USE students;
DROP TABLE stuinfo;
SHOW INDEX FROM stuinfo;
DESC stuinfo;
CREATE TABLE stuinfo(
		id INT PRIMARY KEY,  #主键
		stuName VARCHAR(20) NOT NULL UNIQUE,#非空
		gender CHAR(1) CHECK(gender='男' OR gender='女'),  #检查约束   
		seat INT UNIQUE, #唯一
		age INT DEFAULT 18, #默认约束
		majorId INT REFERENCES major(id) #外键
);

CREATE TABLE major(
		id INT PRIMARY KEY,
		majorName VARCHAR(20)
);
DESC stuinfo;
#查看stuinfo表中所有的索引
SHOW INDEX FROM stuinfo;

#2.-------------------------添加表级约束--------------------------
/*
语法: 在各个字段的最下面
[CONSTRAINT 约束名] 约束类型(字段名)
*/

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
		id INT,
		stuName VARCHAR(20), 
		gender CHAR(1),
		seat INT,
		age INT,
		majorId INT,
		seat2 INT,
		
		CONSTRAINT pk PRIMARY KEY(id, stuName),#主键
		CONSTRAINT uq UNIQUE(seat,seat2), #唯一键
		CONSTRAINT ck CHECK(gender='男' OR gender = '女'), #检查约束
		CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)#外键
);
SHOW INDEX FROM stuinfo;

#通用的写法:
CREATE TABLE IF NOT EXISTS stuinfo(
		id INT PRIMARY KEY,
		stuName VARCHAR(20) NOT NULL,
		gender CHAR(1),
		age INT DEFAULT 18,
		seat INT UNIQUE,		
		majorId INT ,
		CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)
);

#二 修改表时添加约束
/*
1.添加列级约束
ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型 新约束;
2.添加表级约束
ALTER TABLE 表名 ADD [CONSTRAINT 约束名] 约束类型(字段名);


*/
DROP TABLE IF EXISTS stuinfo;
SELECT * FROM stuinfo;
SHOW INDEX FROM stuinfo;
CREATE TABLE stuinfo(
		id INT,
		stuName VARCHAR(20), 
		gender CHAR(1),
		seat INT,
		age INT,
		majorId INT,
		seat2 INT
);
DESC stuinfo;
#1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NOT NULL;
#1.1.删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NULL;

#2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 19;

#3.添加主键
#3.1列级约束
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
#3.2表级约束
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

#4.添加唯一
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
ALTER TABLE stuinfo ADD UNIQUE(seat);

#5.添加外键
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY (majorId) REFERENCES major(id);

#三 =================修改表时删除约束====================
#1.删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NULL;

#2. 删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;

#3.删除主键
ALTER TABLE stuinfo DROP PRIMARY KEY;
ALTER TABLE stuinfo MODIFY COLUMN id INT;

#4.删除唯一键
ALTER TABLE stuinfo DROP INDEX seat;

#5.删除外键
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major;
SHOW INDEX FROM stuinfo;

#=================Prac==================
USE test;
#1.

DESC emp5;
ALTER TABLE emp5 DROP PRIMARY KEY;
ALTER TABLE emp5 MODIFY COLUMN employee_id INT PRIMARY KEY;
ALTER TABLE emp5 ADD CONSTRAINT my_emp_id_pk PRIMARY KEY(employee_id);

#2.
DESC dept2;
ALTER TABLE dept2 DROP PRIMARY KEY;
ALTER TABLE dept2 MODIFY COLUMN department_id INT PRIMARY KEY;
ALTER TABLE dept2 ADD CONSTRAINT my_dept_id_pk  PRIMARY KEY(department_id);

#3.
DESC emp5;
SHOW INDEX FROM emp5;
ALTER TABLE emp5 DROP FOREIGN KEY fk_emp5_dept1;
ALTER TABLE emp5 ADD COLUMN dept_id INT;
ALTER TABLE emp5 ADD CONSTRAINT fk_emp5_dept1 FOREIGN KEY (dept_id) REFERENCES dept1(id);


#级联删除
#从表引用主表数据,直接删除主表会报错, 
#在添加外键最后加上 ON DELETE CASCADE;
SELECT * FROM major;
SELECT * FROM stuinfo;
DESC stuinfo;
SHOW INDEX FROM major;
SHOW INDEX FROM stuinfo;
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stu_major;

ALTER TABLE major MODIFY COLUMN id INT PRIMARY KEY;


ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorId) REFERENCES major(id);


INSERT INTO major
VALUES(1,'java'), (2,'h5'), (3,'big data');

INSERT INTO stuinfo
SELECT 1, 'a1','male',NULL, NULL, 1, NULL UNION ALL
SELECT 2, 'a1','male',NULL, NULL, 2, NULL UNION ALL
SELECT 3, 'a1','male',NULL, NULL, 2, NULL UNION ALL
SELECT 4, 'a1','male',NULL, NULL, 1, NULL UNION ALL
SELECT 5, 'a1','male',NULL, NULL, 3, NULL UNION ALL
SELECT 6, 'a1','male',NULL, NULL, 3, NULL;

#删除专业表的3号专业
DELETE FROM major WHERE id=2;

#方式一 级联删除
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorId) REFERENCES major(id) ON DELETE CASCADE;
#方式二 级联置空
ALTER TABLE stuinfo ADD CONSTRAINT fk_stu_major FOREIGN KEY(majorId) REFERENCES major(id) ON DELETE SET NULL;




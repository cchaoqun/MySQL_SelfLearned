#视图
/*
含义: 虚拟表 和普通表一样使用
mysql5.1版本出现的新特性,通过表生成的数据

		创建语法的关键字	是否实际占用物理空间	使用
视图	create view			没有(仅保存了sql逻辑)		增删改查,一般不能增删改

表		create table			占用(保存实际数据) 		增删改查

*/
#案例: 查询姓张的学生名和专业名
SELECT * FROM major;
SELECT * FROM stuinfo;
DELETE FROM major;
DELETE FROM stuinfo;
INSERT INTO major VALUES(1,'java');
INSERT INTO stuinfo VALUES(8,'张三', '男', 10, 20,1,10);

SELECT stuName, majorName
FROM stuinfo s
INNER JOIN major m
ON s.majorId = m.`id`
WHERE s.stuName LIKE "张%";

#生成视图
CREATE VIEW v1
AS
SELECT stuName, majorName
FROM stuinfo s
INNER JOIN major m
ON s.majorId = m.`id`;

#使用视图
SELECT * FROM v1 WHERE stuName LIKE "张%";

#一 ============创建视图==============
/*
语法:
CREATE view 视图名
AS
查询语句;

*/
USE myemployees;
#1.查询邮箱中包含a字符的员工名,部门名和工种信息
#创建视图查看员工名 部门名和工种信息
CREATE VIEW my_v1
AS
SELECT e.last_name, d.department_name, j.job_title, e.email
FROM employees e
INNER JOIN departments d ON e.department_id=d.department_id
INNER JOIN jobs j ON e.job_id=j.job_id;

SELECT * FROM e1 WHERE last_name LIKE "%a%";


#2.查询各部门的平均工资级别

#创建视图查看各部门的平均工资
CREATE VIEW myv2
AS
SELECT AVG(salary) ag, department_id
FROM employees
GROUP BY department_id;
#使用
SELECT myv2.ag, g.grade_level
FROM myv2 
INNER JOIN job_grades g
ON myv2.ag BETWEEN g.lowest_sal AND g.highest_sal;

#3.查询平均工资最低的部门信息
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

CREATE OR REPLACE VIEW myv3
AS
SELECT *
FROM departments d
WHERE d.department_id = (
	SELECT department_id
	FROM myv2
	WHERE myv2.ag = (
		SELECT MIN(myv2.ag) FROM myv2
	)
);
SELECT * FROM myv3;
#4.查询平均工资最低的部门名和工资
CREATE VIEW myv3
AS
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

SELECT d.*, m.ag
FROM departments d
INNER JOIN myv3 m
ON d.department_id = m.department_id;


#二==========视图的修改=============
#方式一:
/*
CREATE or REPLACE view 视图名
AS
查询语句;

*/

CREATE OR REPLACE VIEW myv3
AS
SELECT AVG(salary) ag, job_id
FROM employees
GROUP BY job_id;

#方式二
/*
语法:
ALTER VIEW 视图名
AS
查询语句;
*/

ALTER VIEW myv3
AS 
SELECT * FROM employees;

#三=======删除视图=========
/*
语法: DROP VIEW 视图名, 视图名,...;


*/

DROP VIEW my_v1, myv2, myv3,e1,s1,s2,s3,s4;

#四=======查看视图========
DESC myv3;
SHOW CREATE VIEW myv3;

#===========Prac============
#1. 创建视图emp_v1, 要求查询电话号码以'011'开头的员工姓名和工资 邮箱
CREATE VIEW emp_v1
AS
SELECT last_name, salary, email
FROM employees
WHERE phone_number LIKE "011%";


#2.创建视图emp_v2 要求查询部门的最高工资高于12000的部门信息
CREATE OR REPLACE VIEW emp_v2
AS 
SELECT d.*,e.mx_sal
FROM departments d
INNER JOIN emp_v22 e
ON d.department_id = e.department_id

CREATE OR REPLACE VIEW emp_v22
AS
SELECT MAX(salary) mx_sal, department_id
FROM employees
GROUP BY department_id
HAVING MAX(salary)>12000;

SELECT * FROM emp_v2;

#五 ==========视图的更新==========
DROP VIEW emp_v1, emp_v2, emp_v22;

CREATE OR REPLACE VIEW myv1
AS
SELECT last_name, email, salary*12*(1+IFNULL(commission_pct,0)) "annual salary"
FROM employees;

CREATE OR REPLACE VIEW myv1
AS
SELECT last_name, email
FROM employees;

SELECT * FROM myv1;
SELECT * FROM employees;
#1.插入
INSERT INTO myv1 VALUES('张飞', 'zhangfei@qq.com');
#2. 修改
UPDATE myv1 SET last_name='张飞1' WHERE last_name='张飞';
#3.删除
DELETE FROM myv1 WHERE last_name='张飞1'

#具备以下特点的视图不允许更新

#1.包含以下关键字的sql语句: 分组函数, distinct, group by, having, union, union all
CREATE OR REPLACE VIEW myv1
AS 
SELECT MAX(salary) mx, department_id
FROM employees
GROUP BY department_id;

#更新
UPDATE myv1 SET mx=9000 WHERE department_id=10;

#2.常量视图
CREATE OR REPLACE VIEW myv2
AS
SELECT 'aaa' NAME;

SELECT * FROM myv2;
#更新
UPDATE myv2 SET NAME='lily';

#3.SELECT 中包含子查询
CREATE OR REPLACE VIEW myv3
AS
SELECT (SELECT MAX(salary) FROM employees) mx_sal;

SELECT * FROM myv3;
#更新
UPDATE myv3 SET mx_sal=10000;

#4.join
CREATE OR REPLACE VIEW myv4
AS
SELECT e.last_name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

SELECT * FROM myv4;
#更新
UPDATE myv4 SET last_name = "张飞" WHERE last_name='Whalen';
INSERT INTO myv4 VALUES('aaa', 'd1');

#5.from一个不能更新的视图
CREATE OR REPLACE VIEW myv5
AS
SELECT * FROM myv3;

SELECT * FROM myv5;
#更新
UPDATE myv5 SET mx_sal=100000 WHERE department_id=60;


#6.where子句的子查询引用了from子句中的表
CREATE OR REPLACE VIEW myv6
AS
SELECT last_name, email, salary
FROM employees
WHERE employee_id IN (
		SELECT manager_id
		FROM employees
		WHERE manager_id IS NOT NULL
);
SELECT * FROM myv6;
#更新
UPDATE myv6 SET salary=1000 WHERE last_name='K_ing';








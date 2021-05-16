#二 sql99语法
/*
语法
	select 查询列表
	FROM 表1 别名
	[连接类型] join 表2 别名
	on 连接条件
	[Where 筛选条件]
	[Group by 分组]
	[Having 筛选条件]
	[Order By 排序列表]


内连接 inner
外连接
	左外 left
	右外 right
	全外 full
交叉连接 cross


*/
#=============内连接===================
/*
语法
	Select 查询列表
	FROM 表1 别名
	inner join 表2 别名
	on 连接条件;
分类:
	等值
	非等值
	自连接
特点:
	1.添加排序 分组 筛选
	2.inner可以省略
	3.筛选条件放在 WHERE 后面, 连接条件放在ON后面
	4.inner join 和sql92语法中的等值连接实现的效果完全相同 都是查询多表的交集

*/
#1. ------------------等值连接-----------------------
#案例1: 查询员工名,部门名
SELECT e.last_name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id=d.department_id;

#案例2: 查询名字中包含e的员工名和工种名
SELECT  e.last_name, j.job_title
FROM employees e
INNER JOIN jobs j
ON e.job_id = j.`job_id`
WHERE e.last_name LIKE "%e%";

#案例3: 查询部门个数>3的城市名和部门个数
SELECT l.city, COUNT(*) AS dep_num
FROM locations l
INNER JOIN departments d
ON l.location_id = d.`location_id`
GROUP BY l.city
HAVING COUNT(*)> 3;

#案例4: 查询哪个部门的员工个数>3的部门名和员工个数,并案个数降序
SELECT d.department_name, COUNT(*) AS emp_num
FROM departments d
INNER JOIN employees e
ON e.department_id = d.`department_id`
GROUP BY d.`department_name`
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC;

#案例5: 查询员工名,部门名,工种名 并按部门名降序
SELECT e.last_name, d.department_name, j.job_title
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN jobs j ON e.job_id = j.`job_id`
ORDER BY department_name DESC;

#2.  ------------------非等值连接-----------------------

#查询员工的工资级别
SELECT e.salary, jg.grade_level
FROM employees e
INNER JOIN job_grades jg
ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal;

#查询每个工资级别的个数>20的个数 并且 按降序排序
SELECT e.salary, jg.grade_level, COUNT(*) grade_count
FROM employees e
INNER JOIN job_grades jg
ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal
GROUP BY jg.`grade_level`
HAVING COUNT(*) > 20 
ORDER BY COUNT(*) DESC;

#3.  ------------------自连接-----------------------
#案例1: 查询员工名和上级的名称
SELECT e.last_name, m.last_name
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.`employee_id`;

#案例2: 查询员工名包含e的员工名和上级的名称
SELECT e.last_name, m.last_name
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.`employee_id`
WHERE e.last_name LIKE "%e%";


#=============外连接===================
/*
应用场景: 一个表中有一个字段, 另一个表中没有
特点:
1.外连接的查询结果为主表中的所有记录
	如果从表中有匹配的,则显示匹配值
	如果从表中没有匹配的,则显示null
	外连接的查询结果=内连接的结果+主表中有而从表中没有的结果
2.	左外连接,left join左边的是主表
	右外连接, right join 右边的是主表
3.	左外和右外交换两个表的顺序,可以实现相同的效果
4.	全外连接 = 内连接的结果+表1中有表2没有(null填充)+表2有表1没有(null填充)的结果

*/
SELECT * FROM beauty;

#查询男朋友不在男生表的女神名
#left outer join beauty 为主表
SELECT be.name
FROM beauty be
LEFT OUTER JOIN boys bo
ON be.boyfriend_id = bo.`id`
WHERE bo.id IS NULL;
#left outer join boys 为主表 在的
SELECT bo.boyName
FROM boys bo
LEFT OUTER JOIN beauty be
ON be.boyfriend_id = bo.`id`
WHERE be.id IS NOT NULL;


#right outer join boys为主表
SELECT be.name
FROM boys bo
RIGHT OUTER JOIN beauty be
ON be.`boyfriend_id` = bo.id
WHERE bo.id IS NULL;

#案例 : 查询哪个部门没有员工
#左外
SELECT d.*, e.employee_id
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

#右外
SELECT d.*, e.employee_id
FROM employees e
RIGHT OUTER JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.employee_id IS NULL

#全外
USE girls;
SELECT be.*, bo.*
FROM beauty be
FULL OUTER JOIN boys bo
ON be.boyfriend_id = bo.id;

#===============交叉连接=================
#结果为两表的笛卡尔 乘积
SELECT be.*, bo.*
FROM beauty be
CROSS JOIN boys bo;


#sql99 VS sql92
/*
功能:sql99支持的较多
可读性:sql99实现连接的条件和筛选条件的分离,可读性提高

*/
#===========Prac=============
#1.
SELECT  be.name, be.id,bo.*
FROM beauty be
LEFT OUTER JOIN boys bo
ON be.`boyfriend_id` = bo.id
WHERE be.id > 3;


#2.
SELECT l.city, d.*
FROM locations l
LEFT JOIN departments d
ON l.location_id = d.location_id
WHERE d.department_id IS NULL;

#3.
SELECT d.department_name, e.*
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE d.department_name IN ("SAL", "IT");









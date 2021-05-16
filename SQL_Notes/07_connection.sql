#进阶6: 连接查询
/*
含义: 又称多表查询,当查询的字段来自于多个表时,就会用到连接查询

笛卡尔乘积现象: 表1有m行 表2有n行 结果=m*n行
发生的原因: 没有有效的连接条件
如何避免: 添加有效的连接

分类:
		按年代分类
		sql92 标准 : 仅支持内连接
		sql99 标准 : 支持内连接+外连接(左外+右外) + 交叉连接
		
		按功能分类
				内连接:
						等值连接
						非等值连接
						自连接
				外连接:
						左外连接
						右外连接
						全外连接
				交叉连接


*/
USE girls;
SELECT * FROM beauty;
SELECT * FROM boys;

SELECT NAME, boyName FROM beauty, boys
WHERE beauty.boyfriend_id = boys.id;

#一  SQL92标准
#1. ===================等值连接======================
/*
1.多表等值连接的结果为多表交集的部分
2.n表连接, 至少需要n-1个连接结果
3. 多表的顺序没有要求
4.一般为表起别名 
5. 可以搭配前面所有查询子句 比如 排序 ORDER BY ,  分组 GROUP BY, 筛选 WHERE

*/
#案例1:  查询女神名和对应的男神名
SELECT NAME, boyName FROM beauty, boys
WHERE beauty.boyfriend_id = boys.id;

#案例2:  查询员工名和对应的部门名
SELECT last_name, department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

#2. 为表起别名
/*
提高语句的整洁度
区分多个重名的字段

注意: 如果为表起了别名,则查询的字段就不能用原来的表名去限定

*/
#查询:  员工名字,工种号,工种名
SELECT last_name, e.job_id, job_title
FROM employees AS e, jobs AS j
WHERE e.job_id = j.job_id;

#3.两个表的顺序是否可以调换
SELECT last_name, e.job_id, job_title
FROM jobs AS j, employees AS e
WHERE e.job_id = j.job_id;

#4.可以加筛选?
#案例1 : 查询有奖金的员工名, 部门名
SELECT last_name, department_name, commission_pct
FROM employees AS e, departments AS d
WHERE e.department_id=d.department_id 
AND  e.commission_pct IS NOT NULL;

#案例2: 查询城市名中第二个字符为'o'的部门名和城市名
SELECT department_name, city
FROM departments AS d, locations AS l
WHERE d.location_id = l.`location_id`
AND l.city LIKE '_o%';

#5. 可以加分组
#案例1: 查询每个城市的部门个数
SELECT city, COUNT(*) AS department_num
FROM locations l, departments d
WHERE l.location_id = d.`location_id`
GROUP BY city;

# 没有group by之前的情况
SELECT  *
FROM locations l, departments d
WHERE l.location_id = d.`location_id`;




#案例2: 有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
SELECT department_name, d.manager_id, MIN(salary), commission_pct
FROM employees AS e, departments AS d
WHERE e.department_id = d.department_id
AND e.commission_pct IS NOT NULL
GROUP BY department_name;

#6. 可以加排序
#案例: 查询每个工种的工种名,和员工的个数,并且按员工个数降序
SELECT job_title, COUNT(*) AS emp_num
FROM employees e, jobs j
WHERE e.job_id = j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;

#7. 可以实现三表连接
#案例; 员工名, 部门名, 和所在的城市
SELECT last_name, department_name, city
FROM employees e, departments d, locations l
WHERE e.department_id = d.`department_id`
AND d.location_id = l.location_id
AND city LIKE "s%"
ORDER BY department_name DESC;


#2. ================非等值连接====================
SELECT * FROM job_grades;
#案例1: 查询员工的工资和工资级别
SELECT salary, grade_level
FROM employees e, job_grades jg
WHERE e.salary BETWEEN jg.lowest_sal AND jg.highest_sal
AND grade_level = 'A';


#3. ====================自连接=========================
#案例1: 查询员工名和上级的名称
/*
查询顺序:
1.第一次看表, 根据last_name找到对应员工的上级领导编号manager_id
2.第二次看表, 根据employee_id 找到对应的last_name
第一次看表找到的manger_id就是第二次看表根据的employee_id

*/
SELECT e.employee_id, e.last_name, m.employee_id, m.last_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

#=======================Prac==============================
#1.
SELECT MAX(salary), AVG(salary)
FROM employees;

#2.
SELECT employee_id, job_id, last_name
FROM employees
ORDER BY department_id DESC, salary ASC;

#3.
SELECT job_id
FROM employees
WHERE job_id LIKE "%a%e%";

#4.
SELECT s.name, g.name, r,score
FROM student s, grade g, result r
WHERE s.gradeId = g.id AND s.id = r.studentNo;

#5.
SELECT CURDATE();
SELECT TRIM('a' FROM "aaaaaaaa      a dsad dsds         aaaaaaaaa");
SELECT SUBSTR("abc", 1);

#====================Prac=========================
#1.
SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

#2.
SELECT e.job_id, d.`location_id`
FROM employees e, departments d
WHERE e.department_id = d.department_id AND e.department_id = 90;

#3.
SELECT e.last_name, d.department_name, l.location_id, l.city, e.commission_pct
FROM employees e, departments d, locations l
WHERE e.department_id  = d.department_id AND d.location_id = l.`location_id`
AND e.commission_pct IS NOT NULL;

#4.
SELECT e.last_name, e.job_id, e.department_id, d.department_name, l.city
FROM employees e, departments d, locations l, jobs j
WHERE e.department_id = d.department_id AND d.location_id = l.location_id 
AND e.job_id = j.job_id
AND l.city = 'Toronto';

#5.
SELECT d.department_name, j.job_title, MIN(e.salary)
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id AND e.job_id = j.`job_id`
GROUP BY j.job_title, d.department_name;

#6.
SELECT l.country_id, COUNT(*) AS depar_num
FROM locations l, departments d
WHERE l.location_id = d.location_id 
GROUP BY l.country_id
HAVING COUNT(*) > 2;

#7.
SELECT e.last_name AS 'employees', e.employee_id AS 'Emp#',
m.last_name AS 'Manager', m.employee_id AS 'Mgr#'
FROM employees e, employees m
WHERE e.manager_id = m.employee_id
AND e.last_name = 'kochhar';












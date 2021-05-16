USE myemployees;
USE employees;
`departments`
#5.进阶5: 分组查询
/*
语法:
	SELECT 分组函数,列(要求出现在group by 后面)
	FROM 表
	WHERE 筛选条件
	GROUP BY 分组的列表
	ORDER BY 子句
注意
	查询列表必须特殊,要求是分组函数和group by 后出现的字段
特点
	1. 分组查询中过得筛选条件分为两类
					数据源 					位置 				关键字
	分组前筛选           原始表 FROM后面的表         group by子句的前面      WHERE
	分组后筛选           分组后的结果集 		        group by子句的后面      HAVING
	
	分组函数做条件 一定放在HAVING子句中
	能用分组前筛选的优先使用分组前筛选
	
	2.GROUP BY 子句支持单个字段,多个字段分组(多个字段之间用逗号隔开没有顺序要求), 表达式或函数
	3.也可以添加排序,排序在整个排序的最后
*/




#引入 查询每个部门的平均工资
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY avg_salary;

#简单的分组查询
#案例1  查询每个工种的最高工资
SELECT MAX(salary), job_id
FROM employees
GROUP BY job_id;

#案例2: 查询每个位置上的部门个数
SELECT location_id, COUNT(*) AS departments_count
FROM departments 
GROUP BY location_id;

#添加筛选条件
#案例1: 查询邮箱中包含a字符的, 每个部门的平均工资
SELECT AVG(salary), department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;

#案例2: 查询有奖金的每个领导手下员工的最高工资
SELECT MAX(salary), manager_id, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL AND commission_pct>0
GROUP BY manager_id;

#添加复杂的筛选条件  分组后而定筛选 HAVING
#查询1: 哪个部门的员工个数>2

#1.查询每个部门的员工个数
SELECT department_id, COUNT(*) AS count_
FROM employees
GROUP BY department_id
HAVING count_ >2;
#2.根据1的结果,查询哪个部门的员工个数>2

#案例2: 查询每个工种 有奖金的员工 的最高工资 >12000 的 工种编号 和 最高工资

SELECT MAX(salary) AS max_salary, job_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING max_salary>12000;


#案例3: 领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个,以及最低工资

SELECT manager_id, MIN(salary) AS min_salary
FROM employees
WHERE manager_id > 102
GROUP BY manager_id
HAVING min_salary > 5000;


#按表达式或函数分组

#案例: 按员工姓名的长度分组, 查询每一组的员工个数, 筛选员工个数>5的个数
SELECT LENGTH(last_name) AS name_len, COUNT(*) AS employee_count
FROM employees
GROUP BY name_len
HAVING employee_count>5;


#按多个字段分组

#案例: 查询每个部门 每个工种的员工的平均工资
#group by 后面的字段一致的放在一行
SELECT AVG(salary) AS avg_salary, department_id, job_id
FROM employees
GROUP BY department_id, job_id;

#添加排序
#案例: 查询每个部门 每个工种的员工的平均工资
# GROUP BY, HAVING, ORDER BY 后面都可以使用别名
SELECT AVG(salary) AS avg_salary, department_id, job_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id, job_id
HAVING AVG(salary) > 10000
ORDER BY AVG(salary) DESC;

#Prac
#1. 
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id
ORDER BY job_id ASC;

#2.
SELECT MAX(salary)-MIN(salary) AS DIFFERENCE
FROM employees;

#3.
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary)>=6000

#4.
SELECT department_id, COUNT(*), AVG(salary)
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC;

#5.
SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id;













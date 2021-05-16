#3 排序查询

/*
语法
	select 查询列表
	from  表
	where 筛选条件
	order by 排序列表 [asc|desc]
特点
	1.asc升序 desc 降序
	如果不写,默认升序
	2. order by 子句中可以支持单个字段 多个字段 表达式 函数 别名
	3. order by 子句一般是放在查询语句的最后面, 但是limit 子句除外

*/

#案例1: 查询员工信息,按照工资从高到低
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY salary ASC;
SELECT * FROM employees ORDER BY salary ;

#案例2:查询部门编号 >=90的员工信息,安入职时间先后排序
SELECT * 
FROM employees 
WHERE department_id >= 90
ORDER BY hiredate ASC; 

#案例3: 按年薪的高低显示员工的信息和年薪 [按别名排序]
SELECT *, salary*12*(1+IFNULL(commission_pct,0)) AS annual_salary
FROM employees
ORDER BY annual_salary DESC;

#案例4: 按年薪的高低显示员工的信息和年薪 [按表达式排序]
SELECT *, salary*12*(1+IFNULL(commission_pct,0)) AS annual_salary
FROM employees
ORDER BY salary*12*(1+IFNULL(commission_pct,0))  DESC;

#案例4: 按姓名的长度显示员工的姓名和工资 [按函数排序]
SELECT LENGTH(last_name) AS nameLen, last_name, salary
FROM employees
ORDER BY nameLen DESC;

#案例5: 查询员工信息,先按工资排序, 再按员工编号排序[按多个字段排序]
# salary相同的情况下 employees_id降序排列
SELECT *
FROM employees
ORDER BY salary ASC, employee_id  DESC ;

#====================Prac======================
#1.
SELECT last_name, department_id, salary*12*(1+IFNULL(commission_pct, 0)) AS annual_salary
FROM employees
ORDER BY annual_salary DESC, last_name ASC;

#2.
SELECT last_name, salary
FROM employees
WHERE NOT(salary BETWEEN 8000 AND 17000)
ORDER BY salary DESC;

#3.
SELECT *, LENGTH(email)
FROM employees
WHERE email LIKE '%e%'
ORDER BY  LENGTH(email) DESC, department_id ASC;


















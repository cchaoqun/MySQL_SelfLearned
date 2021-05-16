#进阶7: 子查询
/*
含义:
	出现在其他语句中的select语句,称为子查询或内查询
	外部的查询语句,称为主查询或外查询
分类:
按子查询出现的位置:
		select 后面:
				仅仅支持标量子查询
		from 后面:
				支持表子查询
		where 或 having后面: *
				标量子查询 (单行)*
				列子查询     (多行)*
				行子查询 (较少)
		
		exists 后面(相关子查询)
				表子查询
按结果集的行列数不同:
		标量子查询 (结果集只有一行一列)
		列子查询 (结果集只有一行多列)
		行子查询 (结果集有一行多列)
		表子查询 (结果集一般为多行多列)
*/

#一 =============where having后面===================
#1. 标量子查询 (单行子查询)
#2. 列子查询 (多行子查询)
#3. 行子查询 (多行多列)
/*
1.子查询放在小括号内
2.子查询一般放在条件的右侧
3.标量子查询 一般搭配着单行操作符使用
>< >= <=  = <>
列子查询 一般搭配着多行操作符使用
in any/some all

4.子查询的执行优先于主查询执行, 主查询的条件用到了子查询的结果
*/

#案例1: 谁的工资被abel高?
#1. 查询Abel的工资
SELECT salary FROM employees e WHERE e.last_name = "Abel";
#2. 查询员工信息,满足salary>1的结果
SELECT last_name, salary
FROM employees
WHERE salary >  (
			SELECT salary 
			FROM employees e 
			WHERE e.last_name = "Abel" 
)
ORDER BY salary;

#案例2: 返回job_id与141号员工相同, salary比143号员工多的员工姓名,job_id和工资
#1.查询141号员工的job_id
SELECT job_id
FROM employees
WHERE employee_id = "141";
#2.查询143员工的salary
SELECT salary
FROM employees
WHERE employee_id="143";
#3.
SELECT last_name, job_id, salary
FROM employees 
WHERE job_id = (
				SELECT job_id
				FROM employees
				WHERE employee_id = "141"
) 
AND salary > (
				SELECT salary
				FROM employees
				WHERE employee_id = "143"
)
ORDER BY salary;

#案例3: 返回公司工资最少的员工的last_name, job_id 和salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
				SELECT MIN(salary)
				FROM employees

);

#案例4: 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
					SELECT MIN(salary)
					FROM employees
					WHERE department_id = "50"
)
ORDER BY MIN(salary);

#-----------------非法使用标量子查询------------------
#子查询的结果不是一行一列

#2.===============列子查询(多行子查询)====================
#案例1: 返回location_id是1400或1700的部门中的所有员工姓名
#join
SELECT last_name, location_id
FROM employees e
JOIN departments d
ON e.department_id = d.`department_id`
WHERE location_id IN (1400, 1700);
#不join
SELECT last_name
FROM employees
WHERE department_id IN (
				SELECT DISTINCT department_id
				FROM departments 
				WHERE location_id IN(1400, 1700)
);
# =ANY 替换 IN
# <>ALL 替换 NOT IN
SELECT last_name
FROM employees
WHERE department_id =ANY (
				SELECT DISTINCT department_id
				FROM departments 
				WHERE location_id IN(1400, 1700)
);

#案例2: 返回其他部门中比job_id为"IT_PROG" 部门任一工资低的员工的:工号 姓名 job_id以及salary

SELECT salary
FROM employees
WHERE job_id = 'IT_PROG';

SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < ANY(
				SELECT DISTINCT salary
				FROM employees
				WHERE job_id = 'IT_PROG'


)AND job_id <> "ID_PROG";

# MAX 替换 ANY
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < (
				SELECT MAX(salary)
				FROM employees
				WHERE job_id = 'IT_PROG'


) AND job_id <> "ID_PROG";


#案例3: 返回其他部门中比job_id为"IT_PROG" 部门所有工资低的员工的:工号 姓名 job_id以及salary
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < ALL(
				SELECT DISTINCT salary
				FROM employees
				WHERE job_id = 'IT_PROG'


)AND job_id <> "ID_PROG";

SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < (
				SELECT MIN(salary)
				FROM employees
				WHERE job_id = 'IT_PROG'


) AND job_id <> "ID_PROG";

#3. ===========行子查询(结果集一行多列或者多行多列)===========
#案例3: 查询员工编号最小,并且工资最高的员工信息
#行子查询
SELECT *
FROM employees
WHERE (employee_id, salary) = (
					SELECT MIN(employee_id), MAX(salary)
					FROM employees
);

#最小employee_id
SELECT MIN(employee_id)
FROM employees;
#最大salary
SELECT MAX(salary)
FROM employees;
#两个条件同时满足
SELECT *
FROM employees
WHERE employee_id = (
				SELECT MIN(employee_id)
				FROM employees
) AND salary = (
				SELECT MAX(salary)
				FROM employees
);

#二 ===============SELECT后面======================

#案例: 查询每个部门的员工个数
SELECT d.*, (
				SELECT COUNT(*)
				FROM employees e
				WHERE e.department_id = d.department_id
) AS depart_emp_count
FROM departments d;

#案例: 查询员工号=102的部门名
SELECT  (
	SELECT department_name
	FROM departments d
	INNER JOIN employees e
	ON d.department_id = e.department_id
	WHERE e.employee_id = 102
) AS depart_name;


#三 ===========FROM后面===============
#查询的结果集当成一张表 必须取别名
#案例1: 查询每个部门的平均工资的工资等级
SELECT AVG(salary), department_id
FROM employees e
GROUP BY department_id;

SELECT av.*, jg.grade_level
FROM (
		SELECT AVG(salary) avg_sal, department_id
		FROM employees e
		GROUP BY department_id
) AS av
INNER JOIN job_grades jg
ON av.avg_sal BETWEEN jg.lowest_sal AND jg.highest_sal;


#四===========exists后面============
/*
子查询的结果是否有值
SELECT EXIST(完整的查询语句)
结果:
1或0
*/
SELECT EXISTS(SELECT employee_id FROM employees);

#案例1: 查询有员工的部门名

SELECT department_name 
FROM departments d
WHERE EXISTS(
			SELECT * 
			FROM employees e
			WHERE d.department_id = e.department_id
);


SELECT department_name
FROM departments d
WHERE d.department_id IN (
					SELECT e.department_id
					FROM employees e
);


#案例2: 查询没有女朋友的男神信息
SELECT bo.*
FROM boys bo
WHERE bo.id IN (
				SELECT be.boyFriend_id
				FROM beauty be 
);

SELECT bo.*
FROM boys bo
WHERE EXISTS(
			SELECT boyFriend_id
			FROM beauty
			WHERE boyFriend_id = bo.id
);

#==========Prac==========
#1.
SELECT last_name, salary, department_id
FROM employees
WHERE department_id = (
				SELECT department_id
				FROM employees
				WHERE last_name = 'Zlotkey'
);

#2
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
			SELECT AVG(salary)
			FROM employees
)
ORDER BY salary;

#3.查询各部门中工资比本部门平均工资高的员工的员工号,姓名,工资
SELECT e.department_id, employee_id, last_name, salary, av.avg_sal
FROM employees e
INNER JOIN (
			SELECT AVG(salary) avg_sal, department_id
			FROM employees e1
			GROUP BY department_id

) AS av
ON e.department_id = av.department_id
WHERE e.salary > av.avg_sal
ORDER BY department_id;

#4.
SELECT employee_id, last_name
FROM employees
WHERE department_id IN (
				SELECT department_id
				FROM employees
				WHERE last_name LIKE "%u%"
);

#5.
#IN 可用 =ANY代替
SELECT employee_id
FROM employees
WHERE department_id IN (
				SELECT DISTINCT department_id
				FROM departments
				WHERE location_id = 1700
);

#6.
SELECT last_name, salary, manager_id
FROM employees
WHERE manager_id IN (
			SELECT DISTINCT employee_id
			FROM employees
			WHERE last_name = "K_ing"
);


#7.
SELECT CONCAT(first_name, '.', last_name) AS last_first_name
FROM employees
WHERE salary = (
			SELECT MAX(salary)
			FROM employees
);


#=========================Prac==========================
#1.查询工资最低的员工信息
SELECT last_name, salary
FROM employees
WHERE salary = (
			SELECT MIN(salary)
			FROM employees
);
#2.查询平均工资最低的部门信息
#(1)各部门的平均工资
SELECT AVG(salary) avg_sal, department_id
FROM employees
GROUP BY department_id;
#(2)各部门平均工资最低的平均工资
SELECT MIN(avg_sal)
FROM(
	SELECT AVG(salary) avg_sal, department_id
	FROM employees
	GROUP BY department_id
) avg_dep;
#(3)部门id=最低的平均工资
SELECT d.*
FROM departments d
WHERE department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary)= (
		SELECT MIN(avg_dep.avg_sal)
			FROM(
				SELECT AVG(salary) avg_sal, department_id
				FROM employees
				GROUP BY department_id
			) avg_dep
	)
);
#方式2
SELECT d.*
FROM departments d
WHERE department_id = (
			SELECT avg_dep.department_id
			FROM (
				SELECT department_id, AVG(salary) av_sal
			        FROM employees
			        GROUP BY department_id
			        ORDER BY av_sal ASC
			        LIMIT 1
			) AS avg_dep		
);

#3. 查询平均工资最低的部门信息和该部门的平均工资
SELECT d.*, av_dep.av_sal
FROM departments d
INNER JOIN (
		SELECT department_id, MIN(salary) av_sal
		FROM employees
		GROUP BY department_id
		ORDER BY MIN(salary) ASC
		LIMIT 1
) av_dep 
ON d.department_id = av_dep.department_id;

SELECT d.*, min_av_sal.avg_sal
FROM departments d
INNER JOIN (
		SELECT department_id, AVG(salary) avg_sal
		FROM employees
		GROUP BY department_id
		HAVING AVG(salary) = (
				SELECT MIN(av_dep.av_sal)
				FROM(
						SELECT AVG(salary) av_sal
						FROM employees
						GROUP BY department_id
				) AS av_dep
		)
) AS min_av_sal
ON d.department_id = min_av_sal.department_id;

#4.查询平均工资最高的job信息
SELECT j.*
FROM jobs j
WHERE job_id = (
			SELECT av_job_sal.job_id
			FROM (
				SELECT job_id, AVG(salary) av_sal
				FROM employees
				GROUP BY job_id
				ORDER BY av_sal DESC
				LIMIT 1
			) AS av_job_sal
);


SELECT j.*
FROM jobs j
WHERE job_id IN (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) = (
				SELECT MAX(av_job.av_sal)
				FROM (
					SELECT AVG(salary) av_sal
					FROM employees
					GROUP BY job_id
				) av_job
		)
);

#如果把平均工资也查询出来
SELECT j.*, avg_job.avg_sal
FROM jobs j
INNER JOIN (
		SELECT AVG(salary) avg_sal, job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) = (
				SELECT MAX(av_j.a_s)
				FROM (
					SELECT AVG(salary) a_s
					FROM employees
					GROUP BY job_id
				) av_j
		
		)
) avg_job
ON j.job_id = avg_job.job_id;




SELECT j.*, av_job_sal.av_sal
FROM jobs j
INNER JOIN (
			SELECT job_id, MIN(salary) AS av_sal
			FROM employees
			GROUP BY job_id
			ORDER BY av_sal DESC
			LIMIT 1
) av_job_sal
ON j.job_id = av_job_sal.job_id;

#5.查询平均工资高于公司平均工资的部门名称
#(1)公司平均工资
SELECT  AVG(salary) FROM employees;

#(2)平均工资高于公司平均工资的部门的department_id
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (
				SELECT AVG(salary) FROM employees
);
#(3)平均工资高于公司平均工资的部门的department_name
SELECT department_name
FROM departments d
WHERE d.department_id IN(
		SELECT department_id
		FROM employees
		GROUP BY department_id
		HAVING AVG(salary) > (
				SELECT AVG(salary) FROM employees
		)
);

#6.查询出公司中所有manager的详细信息
#(1) 查询所有manager_id
SELECT DISTINCT manager_id FROM employees
#(2) 查询manager_id对应employee_id的详细信息
SELECT *
FROM employees
WHERE employee_id IN (
			SELECT DISTINCT manager_id FROM employees
);

#7.各个部门中 最高工资中最低的那个部门的最低工资是多少
#(1) 每个部门的最高工资最低的那个部门
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY MAX(salary) ASC
LIMIT 1;
#(2) 每个部门最高工资最低的那个部门id
SELECT MIN(salary)
FROM employees
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			ORDER BY MAX(salary) ASC
			LIMIT 1
);

SELECT MIN(salary)
FROM employees
GROUP BY department_id
HAVING department_id = (
		SELECT department_id
		FROM employees
		GROUP BY department_id
		HAVING MAX(salary) =(
			SELECT MIN(max_dep.max_sal)
				FROM (
					SELECT department_id, MAX(salary) max_sal
					FROM employees
					GROUP BY department_id
				) max_dep
		)
);

#8.查询平均工资最高的部门的manager的详细信息
#(1)查询平均工资最高的部门
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 1
#(2) 查询对应manager信息
SELECT *
FROM employees
WHERE department_id = (
		SELECT department_id
		FROM employees
		GROUP BY department_id
		ORDER BY AVG(salary) DESC
		LIMIT 1
);

SELECT *
FROM employees e
INNER JOIN departments d
ON d.manager_id = e.employee_id
WHERE d.department_id = (
		SELECT department_id
		FROM employees
		GROUP BY department_id
		HAVING AVG(salary) = (
		SELECT MAX(av_dep.av_sal)
		FROM(
			SELECT AVG(salary) av_sal
			FROM employees
			GROUP BY department_id
			)av_dep
		)
);
























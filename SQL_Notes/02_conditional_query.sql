#进阶2: 条件查询

/*

语法:
	SELECT 
		查询列表
	FROM
		表名
	WHERE
		筛选条件;
执行顺序
1.查看对应表名是否存在
2.对应筛选条件
3.选择

分类:
	1.按条件表达式筛选
	条件运算符: > < =等于 <>不等 >= <=
	
	2.按逻辑表达式筛选
	作用: 用于连接条件表达式
	逻辑运算符: 
		&& || !
		and or not 推荐使用
	
	3.模糊查询
		like 
		between and 
		in 
		is null	

*/

#打开需要查询的库名
USE employees;

#1.按条件表达式筛选
#案例1: 查询工资>12000的员工信息

SELECT 
	*
FROM 
	employees
WHERE
	salary > 12000;

#案例2: 查询部门编号不等于90号的员工名和部门编号
SELECT
	last_name, 
	department_id
FROM 
	employees
WHERE
	department_id <> 90;

#2.按逻辑表达式筛选
#案例1: 查询工资在10000到20000之间的员工名,工资以及奖金

SELECT
	last_name,
	salary,
	commission_pct
FROM 
	employees
WHERE
	(salary>=10000) AND (salary<=20000);
	
#案例2: 部门编号不是在90到110之间,或者工资高于15000的员工信息
SELECT 
	*
FROM 
	employees
WHERE
	(department_id <90 OR department_id>110) 
	OR
	(salary>15000);

SELECT 
	*
FROM 
	employees
WHERE
	NOT(department_id>=90 AND department_id<=110)
	OR
	(salary>15000);
	
#3.模糊查询

/*
like 
	% 代表通配符 任意多个字符,包含0个字符
	_ 代表任意单个字符
	\ 转移字符,如果需要查询的字符为匹配字符,前面加\
		或者需要转义字符前加 任意字符, 字符串后面加上 ESCAPE '任意字符' 等于代替了转移字符\
between and 
in
is null | is not null
*/

#1.like
#案例1: 查询员工名字中包含字符a的员工信息

SELECT
	*
FROM 
	employees
WHERE 
	last_name LIKE '%a%';

#案例2: 查询员工名中第三个字符为n第五个字符为l的员工名字和工资
SELECT 
	last_name,
	salary
FROM 
	employees
WHERE
	last_name LIKE '__n_l%';

#案例3:查询员工名中的第二字字符为_的员工名
SELECT
	*
FROM 
	employees
WHERE 
	last_name LIKE '_$_%' ESCAPE '$';
	
#案例4: like用于查询数字 100多的department_id
SELECT
	*
FROM 
	employees
WHERE
	department_id LIKE "1__";
	
#2.between and
/*
提高语句的
包含临界值
两个临界值不能颠倒顺序 等价于将between换成>= and 换成<=
*/


#案例1: 查询员工编号在100到120之间的员工信息
SELECT
	*
FROM
	employees
WHERE
	employee_id BETWEEN 100 AND 120;
	
#3.in
/*
含义:判断某字段的值是否属于in列表中的某一项
特点
	提高简洁度
	in列表的值类型必须一致或兼容
	in 等价于= 所以不能使用通配符


*/
#案例: 查询员工的工种编号IT_PROG AD_VP AD_PRES中的一个员工名和工种编号
SELECT
	last_name,
	job_id
FROM
	employees
WHERE
	job_id IN ('IT_PROG', 'AD_VP', 'AD_PRES');
	
#4. is null
/*
= <> 不能用于判断null值
is null 或 is not null 可以判断null值


*/

#案例1:查询有奖金的员工名和奖金率
SELECT
		last_name,
		commission_pct
FROM 
		employees
WHERE
		commission_pct IS  NOT NULL;
	
	
#安全等于:  <=>	
/*
安全等于用于判断是否相等,
	可用于数值判断
	也可用于判断 null


*/

#案例1:查询没有奖金的员工名和奖金率
SELECT
		last_name,
		commission_pct
FROM 
		employees
WHERE
		commission_pct <=> NULL;
	
#案例2: 查询工资=12000的员工信息

SELECT 
	last_name,
	salary
FROM 
	employees
WHERE
	salary <=>12000;	
	
# is null pk <=>
/*
IS NULL  :  仅判断null值 可读性高建议使用
<=>		:  既可以判断NULL值,又可以判断普通的数值,可读性低


*/
	
#练习
#ISNULL的使用, ISNULL(字段值), 是null 返回1 不是null返回0
SELECT
	ISNULL(commission_pct), commission_pct
FROM 
	employees;

#1. 查询员工号为176的员工的姓名和部门号和年薪
SELECT
	last_name,
	department_id,
	salary*12*(1+IFNULL(commission_pct, 0)) AS annual_salary
FROM 
	employees
WHERE
	employee_id = 176;

#2.
SELECT
	salary,
	last_name
FROM 
	employees
WHERE
	commission_pct IS NULL AND salary<18000;

#3.
SELECT
	*
FROM 
	employees
WHERE
	job_id NOT IN ('IT_PROG') OR salary=12000;

#4.
DESC departments;

#5
SELECT
	DISTINCT location_id
FROM 
	departments



















#4. 常见函数
/*

概念: 类似于java的方法,将一组逻辑语句语句封装在方法体中
好处 1.隐藏了实现细节, 2.提高代码的重用性
调用:  SELECT 函数名(实参列表)  FROM 表;
特点: 
		1.函数名
		2.函数功能
分类:
		1.单行函数
		 concat length ifnull
		2.分组函数
		功能:做统计使用,又称为统计函数
常见函数:
		字符函数:
		length
		concat
		upper
		lower
		instr
		substr
		trim
		lpad
		rpad
		replace
		
		数学函数
		round 
		floor
		ceil
		truncate
		mod 
		
		日期函数
		now
		curdate
		curtime 
		year 
		month
		day
		hour
		minute
		second
		str_to_date
		date_format
		
*/
USE myemployees;
USE employees;

#一.字符函数
#1. LENGTH 获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('张三丰hahaha');

#查看编码格式
SHOW VARIABLES LIKE '%char%'

#2. concat 拼接字符串

SELECT CONCAT(last_name, '_', first_name) AS `name` FROM employees;

#3. upper lower
SELECT UPPER('john');
SELECT LOWER('John');

#示例: 将姓变大写,名变小写 然后拼接
SELECT CONCAT(LOWER(last_name), '_', UPPER(first_name)) AS `name` 
FROM employees;

#4. substr
#注意索引从1开始
# (str, start_position) 截取从start_position开始包括在内后面所有的字符
SELECT SUBSTR('A123456B', 8) AS out_put;

# 截取从指定索引处指定字符长度的字符
SELECT SUBSTR('AAA123BBB', 1, 3) AS out_put;

#案例; 姓名中首字符大写,其他字符小写,然后用_拼接显示出来
SELECT CONCAT(UPPER(SUBSTR(last_name, 1, 1) ), '_', LOWER(SUBSTR(last_name,2))) AS `name`
FROM employees;

#5. instr
#返回子串在主串中第一次出现的索引, 否则返回0
SELECT INSTR('AAA123AstrAA23str', 'str') AS `index`;

#6. trim
# 去掉字符串前后的空格
SELECT LENGTH(TRIM('                 sada                 ')) AS 'name';
# 按照指定的字符前后去掉
SELECT TRIM('aa' FROM 'aaaaaaaaaaaAAAaaaaaaaasdsaAAAaaaaaaaaaaaa') AS out_put;

#7. lpad 用指定的字符实现字符左填充指定长度
# 如果指定长度小于本身字符串长度, 右截断
SELECT LPAD('abc', 2, '*') AS out_put;
SELECT LPAD('abc', 10, '*') AS out_put;

#8. rpad 用指定的字符实现字符右填充指定长度
# 如果指定长度小于本身字符串长度, 同样右截断
SELECT RPAD('abc', 12, 'AA') AS out_put;
SELECT RPAD('abc', 2, 'AA') AS out_put;

#9. replace 替换
SELECT REPLACE('AAAdsadasdAAAAAAA', 'AAA', 'BBB') AS out_put;


#二 数学函数

#1. round 四舍五入
SELECT ROUND(-1.55);
SELECT ROUND(1.567, 2);

#2. ceil 向上取整, 返回>=该参数的最小整数
SELECT CEIL(-1.02); #-1
SELECT CEIL(1.02);#2
SELECT CEIL(1.00);#1

#3. floor 向下取整, 返回<=该参数的最大整数
SELECT FLOOR(-9.99);#-10
SELECT FLOOR(9.99);#9

#4. truncate 阶段
#第二个参数表示小数点后保留几位
SELECT TRUNCATE(1.65, 1); #1.6

#5. mod 取余
#mod(a,b) : a-a/b*b
SELECT MOD(-10, -3);
SELECT MOD(10, -3);

#三 日期函数

#1. now 返回当前系统日期+时间
SELECT NOW();
#2.  curdate 返回当前系统日期, 不包含时间
SELECT CURDATE();
#3. curtime 返回当前时间,不包含日期
SELECT CURTIME();

# 可以获取指定的部分, 年 月 日 小时 分钟 秒
SELECT YEAR(NOW()) `year`;
SELECT YEAR('2025-01-01') `year`;
SELECT YEAR(hiredate) 'year' FROM employees;

SELECT MONTH(NOW()) `month`;
SELECT DAY(NOW()) 'day';
SELECT HOUR(NOW()) 'hour';
SELECT MINUTE(NOW()) 'minute';
SELECT SECOND(NOW()) 'second';

#str_to_date 将字符通过指定的格式转换成日期
SELECT STR_TO_DATE('2025-3-2', '%Y-%c-%d') AS out_put;

#查询 入职日期为1992-4-3的员工信息
SELECT * FROM employees WHERE hiredate = '1992-4-3';

SELECT * FROM employees WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y');

#date_format 将日期按指定格式转化成字符
SELECT DATE_FORMAT(NOW(), '%y年%m月%d日') AS out_put;

#查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT last_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS 'date' , commission_pct
FROM employees 
WHERE commission_pct IS NOT NULL AND commission_pct > 0;

#四 其他函数

#查看MySQL版本号
SELECT VERSION();
#查询当前数据库
SELECT DATABASE();
#查询当前用户
SELECT USER();

#五 流程控制函数
# if 函数: if else 的效果
# if(exp1, exp2, exp3) exp1=条件表达式; exp2=exp1为真 返回exp2; exp3= exp1为假 返回exp3

SELECT IF(10>5, 'big', 'small');

SELECT last_name, commission_pct, 
IF(commission_pct IS NOT NULL AND commission_pct>0, 'with commission', 'without commission') AS 'status'
FROM employees;

#2. case函数的使用一: switch case的效果
/*
语法
case: 要判断的字段或表达式
when 常量1 then 要显示的值1或语句1
when 常量2 then 要显示的值2或语句2
...
else 要显示的值n或语句n
end
*/

/*
案例: 查询员工的工资, 要求
部门号=30, 显示的工资为1.1倍
部门号=40, 显示的工资为1.2倍
部门号=50, 显示的工资为1.3倍
其他部门原工资

*/


SELECT salary AS origin_salary, department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS new_salary
FROM employees;

#3. case 函数的使用二: 类似于多重if
/*
语法
case
WHEN 条件1 THEN 要显示的值1或语句1
WHEN 条件2 THEN 要显示的值1或语句2
...
ELSE 要显示的值n或语句n
END
*/

#案例: 查询员工的工资情况 根据工资情况分级
SELECT salary AS origin_salary,
CASE
WHEN salary>20000 THEN 'A'
WHEN salary>15000 THEN 'B'
WHEN salary>10000 THEN 'C'
ELSE 'D'
END AS salary_level
FROM employees
ORDER BY salary_level;

#练习
#1. 显示系统时间
SELECT NOW();
#2. 查询员工号,姓名,工资,工资提高20%后的结果
SELECT employee_id, last_name, salary, salary*1.2 AS new_salary
FROM employees;

#3. 将员工的姓名按首字母排序,并写出姓名的长度
SELECT LENGTH(last_name) AS len, SUBSTR(last_name, 1, 1) AS first_, last_name
FROM employees
ORDER BY first_; 

#4
SELECT CONCAT(last_name, ' earns ', salary, ' monthly but wants ', salary*3) AS 'Dream Salary'
FROM employees
WHERE salary=24000;

SELECT last_name, job_id AS job,
CASE job_id
WHEN 'AD_PRES' THEN 'A'
WHEN 'ST_MAN' THEN 'B'
WHEN 'IT_PROG' THEN 'C'
END AS GRADE
FROM employees
WHERE job_id = 'AD_PRES';


#对输入自动加密
# password('字符');
# MD5('字符')
SELECT MD5('王世宇');






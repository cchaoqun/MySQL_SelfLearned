# 二 分组函数
/*
功能: 用作统计使用,又称为聚合函数或统计函数或分组函数

分类:
	sum 求和
	avg 平均值
	max 最大值
	min 最小值
	count 计算个数
特点:
	1.sum avg 一般用于处理数值
	2.max min count 可以处理任何类型
	3.是否忽略null值
		以上分组函数全部忽略null值
	4.可以和distinct搭配实现去重的运算
	5.count函数的介绍
	一般使用(*) 统计行数
	6. 和分组函数一同查询的字段要求是group by后的字段
*/

#1. 简单的使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

SELECT SUM(salary) 'sum', ROUND(AVG(salary), 2) 'avg', ROUND(MAX(salary),2) 'max', MIN(salary) 'min', COUNT(salary) 'count'
FROM employees;

#2. 参数支持哪类类型
#不会报错但是没有意义 不要使用
SELECT SUM(last_name), AVG(last_name) FROM employees;
SELECT SUM(hiredate), AVG(hiredate) FROM employees;

#可以使用,因为这些字段是可以排序的
SELECT MAX(last_name), MIN(last_name) FROM employees;
SELECT MAX(hiredate), MIN(hiredate) FROM employees;

#只统计非null的个数
SELECT COUNT(commission_pct), COUNT(last_name) FROM employees;

#3. 忽略null
# sum avg 都忽略null值
SELECT SUM(commission_pct) , AVG(commission_pct), SUM(commission_pct) / 35, SUM(commission_pct) / 72
FROM employees;

# max min
SELECT MAX(commission_pct), MIN(commission_pct) FROM employees;

#count
SELECT COUNT(commission_pct) FROM employees;

#4. 可以和distinct搭配实现去重的运算
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;
SELECT COUNT(DISTINCT salary), COUNT(salary) FROM employees;

#5. count函数的详细介绍
SELECT COUNT(salary) FROM employees;
#  * 统计行数
SELECT COUNT(*) FROM employees;
# 增加一列的1,统计右多少行2 可以加一个常量值, 等价于增加了一列这个常量值
SELECT COUNT(1) FROM employees;

#效率
#  MYISAM 存储引擎下, COUNT(*)的效率高
#  INNODB存储引擎下, COUNT(*) 和COUNt(1)的效率差不多,比COUNT(字段)高一些
# 引入如果COUNT(字段) 需要判断这一行的字段是否为null多了一步判断

#6. 和分组函数一同查询的字段有限制
# 统计每个employee_id对应的平均工资
SELECT AVG(salary), employee_id 
FROM employees
GROUP BY employee_id;

# Prac

#1.
SELECT MAX(salary), MIN(salary), ROUND(AVG(salary),2), COUNT(salary) FROM employees;

#2. 
#  DATEDIFF (date1, date2) = date1-date2 相差的天数
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) AS diff
FROM employees;

#3.
SELECT COUNT(*) 'count' FROM employees WHERE department_id = 90;















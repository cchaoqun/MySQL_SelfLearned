#进阶1: 基础查询
/*
语法
select 查询列表
from 表名;

类似于: System.out.ptintln(打印东西);

特点:

1.查询列表可以使:表中的字段 常量值 表达式 函数
2.查询的结果是一个虚拟的表格

*/
#打开需要查询的库名
USE myemployees;

#1.查询表中的单个字段
SELECT last_name FROM employees;

#2.查询表中的多个字段
SELECT last_name, email, salary FROM employees;

#3.查询表中的所有字段 F12格式化
#*显示的字段顺序和表中的相同
# ` 着重号,区分字段和关键字
#选中SQL语句再执行
SELECT 
  * 
FROM
  employees ;
  
 #4.查询常量值
 #显示常量值本身
 SELECT 100;
 SELECT 'john';
 
 #5.查询表达式
 SELECT 100*98;
 SELECT 100%98;

 #6.查询函数
 #调用该方法,并显示该方法的返回值
 SELECT VERSION();

#7.为字段起别名
/*
1.便于理解
2.如查询的字段有重名的情况,使用别名可以区分开来
*/
#方式1 AS
SELECT 100 %98 AS `mod`;
SELECT last_name AS lname, first_name AS fname FROM employees;
#方式2 使用空格 
SELECT last_name lname, first_name fname FROM employees;

#案例 查询salary 显示结果为out put
#显示的名称有关键字 或者空格 或者#, 用""括起来 避免歧义
SELECT salary AS "OUT PUT" FROM employees;

#8.去重
#案例: 查询员工变种涉及到的所有的部门编号
#在显示的字段前面加上关键字 DISTINCT
SELECT DISTINCT department_id FROM employees;

#9.+号的作用
/*
java中的+号
运算符
连接符

mysql中的+号
仅仅只有一个功能;运算符
SELECT 100+90; 两个操作数都为数值型,则做加法运算
SELECT '123' + 90; 其中的一方为字符型,师徒转换成数字型
			如果转换成功,则继续加法运算
SELECT 'john'+90	如果转换失败, 则字符型数值转换成0
SELECT null+10; 	只要其中有null,结果为null
*/

#案例: 查询员工名和姓连接成一个字段并显示为 姓名
#使用 CONCAT函数进行拼接
SELECT CONCAT('a', 'b', 'c') AS test;

SELECT CONCAT(last_name, " ", first_name) AS `name` FROM employees;

#Practice
#1.显示表departments的结构,并查询其中的全部数据
#DESC (describe)
DESC departments;
SELECT * FROM departments;
#2.显示表employees中的全部job_id(不能重复)
SELECT DISTINCT job_id FROM employees;
#3.显示employees的全部列,各个列之间用逗号隔开链接,列头显示为"OUT PUT"

#但是某些字段为null,结果全为null
#IFNULL(exp1, exp2) exp1可能为null的字段名 exp2如果为null,代替的值
#这里如果为null,代替为0
SELECT IFNULL(commission_pct, 0) AS comission_pct_NoNull,
	commission_pct
FROM 
	employees;

#--------------------------------------------------------
SELECT
	CONCAT(`first_name`, ",", `last_name`,",",`phone_number`, ",", IFNULL(commission_pct, 0)) AS "OUT PUT"
FROM 
	employees;























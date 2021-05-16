#函数
/*
存储过程和函数: 类似于java中的方法
好处:
1.提高代码的重用性
2. 简化操作
3.减少了编译次数并且减少了和数据库服务器的链接次数,提高了效率

区别:
存储过程 可以有0个或多个返回 适合做批量插入更新
函数: 有且仅有1个返回 处理数据后返回一个结果
*/

#一 创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN 
		函数体


END
/*
注意:
1.参数列表 包含两部分
参数名 参数类型

2. 函数体: 肯定会有 return语句 如果没有会保存
如果return语句没有放在函数体的最后也不报错 但不建议

return 值;
3. 函数体中仅有一句话, 则可以省略begin end
4. 使用delimiter语句设置结束标记

*/

#二 调用语法
SELECT 函数名(参数列表)
#--------------------------------案例-------------------------------------
#1.无参有返回
#案例: 返回公司的员工个数
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN 
	DECLARE c INT DEFAULT 0;
	SELECT COUNT(*) INTO c FROM employees;
	RETURN c;
END $
SELECT myf1() $

#2.有参有返回
#案例1: 根据员工名 返回他的工资
SELECT * FROM employees;
DESC employees;

CREATE FUNCTION myf2(ename VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @dol=0;
	SELECT salary INTO @dol
	FROM employees
	WHERE last_name = ename;
	RETURN @dol;
END $
SELECT myf2('Kochhar') $

#案例2: 根据部门名 返回该部门的平均工资
SELECT * FROM departments;
CREATE FUNCTION myf3(depname VARCHAR(20)) RETURNS DOUBLE
BEGIN 
		DECLARE sal DOUBLE;
		SELECT AVG(e.salary) INTO sal
		FROM employees e
		INNER JOIN departments d
		ON e.department_id = d.department_id
		WHERE d.department_name = depname
		GROUP BY d.department_name;
		RETURN sal;
END $
SELECT myf3('Adm') $

#三 查看函数
SHOW CREATE FUNCTION myf3 ;

#四 删除函数
DROP FUNCTION myf3 ;

#==================Prac================
#1. 创建函数 实现传入两个float 返回二者之和
CREATE FUNCTION test(f1 FLOAT, f2 FLOAT) RETURNS FLOAT
BEGIN
		DECLARE mySum FLOAT DEFAULT 0;
		SELECT f1+f2 INTO mySum;
		RETURN mySum;
END $
SELECT test(1.0, 2.6) $







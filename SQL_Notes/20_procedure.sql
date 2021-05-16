#存储过程和函数
/*
存储过程和函数: 类似于java中的方法
好处:
1.提高代码的重用性
2. 简化操作
3.减少了编译次数并且减少了和数据库服务器的链接次数,提高了效率

*/

#存储过程
/*
含义: 一组预先编译好的SQL语句的集合, 理解成批处理语句

*/

#一 创建语法
CREATE PROCEDURE 存储过程名(参数列表)
BEGIN

		存储过程体(一组合法的SQL语句)


END
/*
注意:
1.参数列表包含三部分
参数模式  参数名 参数类型
举例:
IN stuname VARCHAR(20)
参数模式:
IN: 改参数可以作为输入.也就是改参数需要调用方法传入值
OUT: 改参数可以作为输出 也就是改参数可以作为返回值
INOUT: 改参数既可以作为输入又可以作为输出, 也就是该参数既需要传入值也可以返回值
*/
/*
#2. 如果存储过程体仅仅只有一句话 BEGIN END 可以省略
存储过程体中的每条SQL语句的结尾要求必须加分号.
存储过程的结尾可以使用 DELIMITER 重新设置
语法:
DELIMITER 结束标记
案例:
DELIMITER $

*/
#二 调用语法
CALL 存储过程名(实参列表);

#空参列表
#案例: 插入到admin表中五条记录
SELECT * FROM admin;
DELETE FROM admin WHERE username LIKE 'aaa%';

CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username, `password`) 
	VALUES('aaa', 111), ('aaa1', 111), ('aaa2', 111), ('aaa3', 111), ('aaa4', 111)
END ;

CALL myp1() ;
SELECT * FROM beauty;
SELECT * FROM boys;
INSERT INTO boys VALUES(4,'aaa', 10);
UPDATE beauty SET boyfriend_id=4 WHERE NAME='柳岩'
#创建带in模式参数的存储过程
#案例1: 创建存储过程实现 根据女神名 查询对应的男神信息
DELIMITER $
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))
BEGIN 
	SELECT bo.*
	FROM boys bo
	RIGHT JOIN beauty be
	ON bo.id=be.boyfriend_id
	WHERE be.name = beautyName;
END $


#案例2: 创建存储过程实现, 用户是否登录成功
DELIMITER $
CREATE PROCEDURE myp3(IN username VARCHAR(20), IN PASSWORD VARCHAR(20))
BEGIN
		DECLARE result INT DEFAULT 0;#声明并初始化
		
		SELECT COUNT(*) INTO result #赋值
		FROM admin
		WHERE admin.username = username
		AND admin.password = PASSWORD;
		
		SELECT IF(result > 0, 'success', 'fail');#使用
END $
#调用
CALL myp3('张飞', '2222') $

#3: 创建带out模式的存储过程
SELECT * FROM beauty;
SELECT * FROM boys;
INSERT INTO beauty VALUES(30, 'girl1', '女', NULL, 1313, NULL, 11);
INSERT INTO boys VALUES(11, 'boy1', 10);
INSERT INTO boys VALUES(12, 'boy1', 11);
#案例1: 根据女神名返回对应的男神名字
DELIMITER $
CREATE PROCEDURE myp55(IN beautyName VARCHAR(20), OUT boyName VARCHAR(20))
BEGIN
		SELECT bo.boyName INTO boyName
		FROM boys bo
		INNER JOIN beauty be
		ON bo.id = be.boyfriend_id
		WHERE be.name = beautyName;

END $

CALL myp4('girl1', @boyName) $
SELECT @boyName $

SHOW VARIABLES LIKE "autocommit";
SET autocommit=1;

#案例1: 根据女神名返回对应的男神名字和魅力值
DELIMITER $
CREATE PROCEDURE myp6(IN beautyName VARCHAR(20), OUT boyName VARCHAR(20), OUT userCP INT)
BEGIN
		SELECT bo.boyName, bo.userCP INTO boyName, userCP
		FROM boys bo
		INNER JOIN beauty be
		ON bo.id = be.boyfriend_id
		WHERE be.name = beautyName;
END $
#调用
CALL myp6('girl1', @bbname, @cp) $
SELECT @bbname, @cp$


#4.创建带inout模式参数的存储过程
#案例1: 传入a和b两个值,最终ab都翻倍并返回
CREATE PROCEDURE myp7(INOUT a INT, INOUT b INT)
BEGIN
	SET a = a*2;
	SET b = b*2;
END $
SET @a = 1;
SET @b = 2;
CALL myp7(@a, @b)$
SELECT @a, @b $

#二 删除存储过程
#语法: DROP PROCEDURE 存储过程名
DROP PROCEDURE myp1 $

#三 查看存储过程信息
SHOW CREATE PROCEDURE myp2;

#=================Prac============
#1.创建存储过程实现传入用户名和密码 插入到admin表中
CREATE PROCEDURE myp8(IN user1 VARCHAR(20), IN pass1 VARCHAR(20))
BEGIN
	INSERT INTO admin(username, PASSWORD) VALUES(user1, pass1);
END$
CALL myp8('user123', '123')$
SELECT * FROM admin WHERE username = 'user123'$

#2. 创建存储过程或函数实现传入女神编号 返回女神名称和女神电话
CREATE PROCEDURE myp9(IN id1 INT, OUT bname VARCHAR(20), OUT ph VARCHAR(20))
BEGIN
		SELECT be.name, be.phone INTO bname, ph
		FROM beauty be
		WHERE be.id = id1;
END$
CALL myp9(30, @bname, @ph)$
SELECT @bname, @ph$


#3.创建存储过程或函数或实现比较两个女神生日 返回大小
CREATE PROCEDURE myp10(IN bir1 DATETIME, IN bir2 DATETIME, OUT res INT)
BEGIN
		SELECT DATEDIFF(bir1, bir2) INTO res;
END $
CALL myp10('1990-10-11', '1990-10-12', @diff)$
SELECT @diff$

#4. 创建存储过程实现传入一个日期,格式化成xx年xx月xx日 并返回
CREATE PROCEDURE test_p1(IN mydate DATETIME, OUT strDate VARCHAR(20))
BEGIN 
		SELECT DATE_FORMAT(mydate, "%Y年%m月%d日") INTO strDate;
END $
CALL test_p1(CURDATE(), @strDate) $
SELECT @strDate $

#5. 创建存储过程实现传入一个女神名称, 返回 女神 and 男神 格式的字符串
DROP PROCEDURE test_p2 $
CREATE PROCEDURE test_p2(IN be VARCHAR(20), OUT str VARCHAR(50))
BEGIN
		SELECT CONCAT(be, ' and ', IFNULL(bo.boyName, ' null')) INTO str
		FROM beauty be
		RIGHT JOIN boys bo 
		ON be.boyfriend_id = bo.id
		WHERE be.name = be;
END $
CALL test_p2('girl1', @str) $
SELECT @str $


#6. 创建存储过程实现传入一个条码标书和起始索引 查询beauty表的记录
DROP PROCEDURE test_p3 $
CREATE PROCEDURE test_p3(IN startIndex INT, IN size INT)
BEGIN
	SELECT * FROM beauty LIMIT startIndex, size;
END $
CALL test_p3(2, 3) $

















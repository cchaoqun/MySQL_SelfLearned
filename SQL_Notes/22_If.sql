#流程控制结构
/*
顺序结构: 程序从上往下依次执行
分支结构: 程序从两条或多条路径中选择一条去执行
循环结构: 程序在满足一定条件的基础上, 重复执行一段代码

*/
#一分支结构

#1. if函数
/*
功能: 实现简单的双分支
语法:
SELECT IF(表达式1, 表达式2, 表达式3)
执行顺序
如果表达式1=true 则 IF 函数返回表达式2的值, 否则返回表达式3的值
*/

#2. case结构
/*
情况1: 类似于java中的switch语句, 一般用于实现等值判断
语法:
	CASE 变量|表达式|字段
	WHEN 要判断的值 THEN 返回的值1 或语句1 ;
	WHEN 要判断的值 THEN 返回的值2 或语句2 ;
	...
	ELSE 要返回的值n或语句n ;
	END CASE ;


情况2: 类似于java中的多重if语句 一般用于实现区间判断
语法:
	CASE 
	WHEN 要判断的条件1 THEN 返回的值1 或语句1 ;
	WHEN 要判断的条件2 THEN 返回的值2 或语句2 ;
	...
	ELSE 要返回的值n或语句n ;
	END CASE;
	
特点:
1.
可以作为表达式 嵌套在其他语句中使用 可以放在任何地方 BEGIN END 里面或外面
可以作为独立的语句去使用, 只能放在 BEGIN END中
2.
如果WHEN中的值满足或条件成立 则执行THEN后面的语句, 并且结束CASE
如果都不满足 则执行ELSE的语句或值
3.
ELSE可以省略, 如果ELSE省略 并且所有WHEN条件都不满足 则返回NULL
*/


#案例
#创建存储过程 根据传入的成绩来显示登记 比如 90-100 A 80-90 B 60-80 C 0-60 C
DELIMITER $
CREATE PROCEDURE test_case(IN score INT)
BEGIN
	CASE
	WHEN score>=90 AND score <=100 THEN SELECT 'A';
	WHEN score >=80 THEN SELECT 'B';
	WHEN score >=60 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE ;
END $
CALL test_case(90) $

#3. IF结构
/*

功能: 实现多重分支
语法:
if 条件1 then 语句1;
elseif 条件2 then 语句2;
...
else 语句n;
end if;

应用在begin end 中



*/
#案例1: 根据传入的成绩来返回登记 比如 90-100 A 80-90 B 60-80 C 0-60 C
CREATE FUNCTION test_if (score INT ) RETURNS CHAR
BEGIN 
		IF score >= 90 AND score <=100 THEN RETURN 'A';
		ELSEIF score >=80 THEN RETURN 'B';
		ELSEIF score >=60 THEN RETURN 'C';
		ELSE RETURN 'D';
		END IF;
END $
SELECT test_if(95) $


#二 循环结构
/*
分类:
while loop
循环控制:
iterate 类似于continue 结束本次循环 继续下一次
leave 类似于 break 跳出 结束当前所在的循环

*/
#1.while
/*
语法:
标签: while 循环条件 do
	循环体;
end while 标签;



*/
#2. loop
/*
语法:
标签: loop
	循环体;
end loop 标签;
可以用来模拟简单的死循环

*/
#3. repeat
/*
语法:
标签: repeat
	循环体;
until 结束循环的条件
end repeat 标签;

*/

#1.没有添加循环控制语句
#案例: 批量插入 根据次数插入到admin表中多条记录
DROP PROCEDURE pro_while1 $
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	WHILE i <=insertCount DO
		INSERT INTO admin (username, `password`) VALUES
		(CONCAT('abc', i), '123');
		SET i = i+1;
	END WHILE;
END $
CALL pro_while1(100) $


#2.添加leave语句
#案例: 批量插入, 根据次数插入到admin表中多条记录,如果次数>20则停止
TRUNCATE TABLE admin $
DROP PROCEDURE pro_while1 $
CREATE PROCEDURE test_while1(IN insertCount INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	a: WHILE i<insertCount DO
		INSERT INTO admin(username, PASSWORD) 
		VALUES(CONCAT('asd', i), CONCAT('pw', i));
		IF i>=20 THEN LEAVE a;
		END IF;
		SET i = i+1;
	END WHILE a;
END $
CALL test_while1(20) $

#3添加 iterate 语句
#只插入偶数次
CREATE PROCEDURE test_while2(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 0;
	a: WHILE i<insertCount DO
		SET i = i+1;
		IF MOD(i,2)!=0 THEN ITERATE a;
		END IF;
		INSERT INTO admin(username, PASSWORD) 
		VALUES(CONCAT('qwe', i), CONCAT('pws', i));
	END WHILE a;
END $
CALL

# repeat

CREATE PROCEDURE test_repeat1(IN c INT)
BEGIN 
	DECLARE i INT DEFAULT 0;
	a: REPEAT
		SET i = i+1;
		IF MOD(i,2)!=0 THEN ITERATE a;
		END IF;
		INSERT INTO admin(username, PASSWORD) 
		VALUES(CONCAT('qwe', i), CONCAT('pws', i));
	UNTIL i>c END REPEAT a;
END $

#============Prac===============
DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent(
	id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(20)
);
DELIMITER $
CREATE PROCEDURE test_randstr_insert(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;#定义一个循环变量 表示插入次数
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startIndex INT DEFAULT 1;#代表起始索引
	DECLARE len INT DEFAULT 1; #达标截取的字符的长度
	WHILE i<=insertCount DO
			SET len = FLOOR(RAND()*(20-startIndex+1)+1);#产生一个随机的整数 长度从1- 26-startIndex+1 content最大长度为20
			SET startIndex = FLOOR(RAND()*26+1); #产生1-26的随机数
			INSERT INTO stringcontent (content) VALUES(SUBSTR(str, startIndex, len));
		SET i = i+1;#循环变量的更新
	END WHILE ;
END $













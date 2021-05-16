#变量
/*
系统变量: 
		全局变量
		会话变量
自定义变量
		用户变量
		局部变量

*/

#一 系统变量
/*说明: 变量由系统提供,不是用户定义的,属于服务器层面
注意:
如果是全局级别,需要加global 如果是会话级别,则需要加session,如果不写,默认session

使用的语法:
1.查看所有的系统变量
SHOW SESSION| GLOBAL VARIABLES;

2.查看满足条件的部分系统变量
SHOW GLOBAL |session VARIABLES LIKE "%char%";

3.查看指定的某个系统变量的值
SELECT @@global | session.系统变量名;

4.为某个系统变量赋值
方式一
set global|session系统变量名 = 值
方式二
set @@global|session.系统变量名=值



*/
#1.全局变量
/*
作用域: 服务器每次启动将为所有的全局变量赋初始值,针对于所以的会话(连接)有效,但是不能跨重启

*/

#查看所有的全局变量
SHOW GLOBAL VARIABLES;
#查看部分全局变量
SHOW GLOBAL VARIABLES LIKE "%char%";
#查看指定的全局变量
SELECT @@global.autocommit;
SELECT @@transaction_isolation;

#为某个指定的全局变量赋值
SET @@global.autocommit=0;


#2 会话变量
/*
作用域: 仅针对当前会话(有效)

*/
#查看所有的会话变量
SHOW SESSION VARIABLES ;
SHOW VARIABLES ;

#查看部分的会话变量
SHOW SESSION VARIABLES LIKE "%char%";
SHOW VARIABLES LIKE "%char%";

#查看指定的某个会话变量
SELECT @@session.transaction_isolation;
SELECT @@transaction_isolation;

#为某个会话变量赋值
#方式一
SET @@session.transaction_isolation = 'read-uncommitted';
#方式二
SET SESSION transaction_isolation = 'repeatable-read';

#二 自定义变量
/*
说明: 变量是用户自定义的 不是系统定义的
使用步骤
声明
赋值
使用(查看, 比较,运算等)


*/
#1.用户变量
/*
作用域: 针对于当前会话(连接)有效, 同于会话变量的作用域
应用在任何地方, 也就是begin end 里面或begin end外面
*/

#1.声明并初始化  赋值操作符 = | :=
/*
SET @用户变量名=值
SET @用户变量名:=值
SELECT @用户变量名:=值
*/
#2.赋值(更新)用户变量的值
#方式一: 通过SET || SELECT
/*
SET @用户变量名=值
SET @用户变量名:=值
SELECT @用户变量名:=值
*/
#方式二: 通过SELECT INTO
/*
SELECT 字段 INTO @变量名 FROM 表
*/

#3.使用(查看用户变量的值)
SELECT @用户变量名;

#案例:
#声明并初始化
SET @name = 'john';
SET @name = 100;	
SET @count = 1;
#赋值
SELECT COUNT(*) INTO @count FROM employees;
#查看
SELECT @count;


#2. 局部变量
/*
作用域: 仅在定义它的begin end中有效
应用在begin end中的第一句话
*/
 
 #1.声明
 DECLARE 变量名 类型;
 DECLARE 变量名 类型 DEFAULT 值;
 
 #2.赋值
/*
SET 局部变量名=值
SET 局部变量名:=值
SELECT @局部变量名:=值
*/
#方式二: 通过SELECT INTO
/*
SELECT 字段 INTO 局部变量名 FROM 表
*/

#3.使用
SELECT 局部变量名;

#对比用户变量和局部变量

			作用域		 	定义和使用的位置					语法
用户变量	当前会话		会话中的任何地方					必须加@ 不用限定类型

局部变量	BEGIN END 中	只能在BEGIN END 中.且为第一句话		一般不用加@ 需要限定类型

#案例: 声明两个变量并附初始值 求和 并打印

#1.用户变量
SET @m=1;
SET @n=2;
SET @sum = @m+@n;
SELECT @sum;

BEGIN
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE SUM INT;
SET SUM = m+n;
END









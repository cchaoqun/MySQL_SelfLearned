#进阶9 : 联合查询
/*
union: 将多条查询语句的结果合并成一个结果
语法:
查询语句1
UNION
查询语句2
UNION
...

应用场景:
要查询的结果来自于多个表,且多个表没有直接的连接关系,且查询信息一致时

特点:
1.要求多条查询语句的查询列数是一致的	
2.要求多条查询语句的类型和顺序最好是一致的
3.union关键默认去重, union all 包含重复项
*/
#查询:部门编号>90 || 邮箱中包含"a"的员工信息
SELECT * FROM employees WHERE department_id>90 || email LIKE "%a%";
#使用union
SELECT * FROM employees WHERE department_id>90
UNION 
SELECT * FROM employees WHERE email LIKE "%a%";

#查询:中国用户中男性的信息 以及外国用户男性的信息
SELECT * FROM t_ca;
SELECT * FROM t_ua;

SELECT * FROM t_ca WHERE csex = '男'
UNION ALL
SELECT * FROM t_ua WHERE tGender = 'male';













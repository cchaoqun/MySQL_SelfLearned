#进阶8: 分页查询
/*
应用场景:当要显示的数据,一页显示不全,需要分页提交SQL请求
语法                                                                  执行顺序
		SELECT 查询列表				7
		FROM 表1 						1
		[join type] join 表2				2	
		on 连接条件						3
		WHERE 筛选条件  				4
		GROUP BY 分组条件 			5
		HAVING 分组后的筛选 			6
		ORDER BY 排序的字段			8
		LIMIT offset, size;					9
		
			offset要显示条目的起始索引 (起始索引从0开始)
			要显示的条目数目
特点:
	1.limit语句放在查询语句的最后 (执行语法都在最后)
	2.公式
	要显示的页数 page, 每页的条目数size
	SELECT 查询列表
	FROM 表
	LIMIT (page-1)*size, size;
*/

#案例1: 查询前5条员工信息
SELECT * FROM employees LIMIT 0,5;
SELECT * FROM employees LIMIT 5;

#案例2: 查询第11条到25条
SELECT * FROM employees LIMIT 10, 15;

#案例3: 有奖金的员工信息,并且工资较高的前10名显示出来
SELECT *
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
LIMIT 10;


#==========Prac===============
#1.
SELECT SUBSTR(email,1,INSTR(email, '@')-1) user_
FROM stuinfo;
#2.
SELECT COUNT(*) AS set_count
FROM stuinfo
GROUP BY sex;
#3.
SELECT s.`name`, g.gradeName
FROM stuinfo s
INNER JOIN grade g
ON s.gradeId = g.id
WHERE s.age > 18;

#4.
SELECT MIN(age), gradeId
FROM stuinfo
GROUP BY gradeId
HAVING MIN(age) > 20;

#查询执行先后
/*									执行顺序                                          
SELECT 查询列表						7
FROM 表								1
连接类型 JOIN 表2						2
ON 连接条件 							3
 WHERE 筛选条件						4	
 GROUP BY 分组条件					5	
 HAVING 分组后筛选条件				6
 ORDER BY 字段						8		
 LIMIT 起始索引,大小					9
 
*/





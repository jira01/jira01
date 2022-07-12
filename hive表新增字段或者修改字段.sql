hive表新增字段或者修改字段

1. hive表操作

	1. 修改表字段的数据类型或者修改表字段名字
		#如果表是外部表，需要先修改为内部表
		alter table 数据库名.表名set tblproperties('EXTERNAL' = 'FALSE');
		ALTER TABLE 数据库名.表名 CHANGE COLUMN 字段名 新的字段名(如果不变就保持原字段) 字段类型(若不变就采用原来的字段) COMMENT '新的字段备注';
		alter table 数据库名.表名set tblproperties('EXTERNAL' = 'TRUE');
		
	2. 新增表字段
	
		#如果是外部表，需要先修改为内部表
		alter table 数据库名.表名 set tblproperties('EXTERNAL' = 'FALSE');
		-- 新增列
		alter table 数据库名.表名add columns(log_id string COMMENT '数据源请求唯一键');
		
		alter table 数据库名.表名set tblproperties('EXTERNAL' = 'TRUE');
		
		
2. 遇到问题

修改或者新增字段之后，数据无法保存进去？
博客https://www.cnblogs.com/zhangqian27/p/12654067.html
原因：hive 1.1.0中表的元数据和分区的元数据是分开管理的，也就是说分区的元数据在分区生成的时候就会保存下来，依据是表的元数据。当我们进行修改字段和新增字段的时候，只是修改了表的元数据，而历史的分区云数据信息并没有改变。当我们查历史分区
的数据的时候，因为表的元数据和分区的元数据不一致了，导致查出的数据为null. 和HDFS无关。

查表的元数据和分区的元数据：

desc 表名;
 
desc 表名 partition(dt='xxxxx')
解决方案：

	a. 新增或修改字段，且需要重新跑数据。删除分区的元数据，重新跑对应分区的数据
	
		alter table 表名 drop partition (dt >= '20201001')
		
		--添加partition
		alter table student_par add IF NOT EXISTS partition(age=10,sex='boy') location '10/boy';
		--再加两个分区
		alter table student_par add IF NOT EXISTS partition (age=11,sex='boy') location '11/boy' partition (age=11,sex='girl') location '11/girl';
			
	b. 只是修改字段，不需要重新跑数据， 在修改时直接指定分区
	
		alter table 表名 partition(dt='20201208') CHANGE COLUMN type_of_charge type_of_charge string COMMENT '计费方式';
		
	c. hive版本是1.1.0之后的可以使用 cascade(级联)， 可以修改所有的元数据。
	
		alter table 表名 add columns(log_id string COMMENT 'xxxxxx') cascade;
 
		alter table 表名 partition(dt='20201208') CHANGE COLUMN type_of_charge type_of_charge string COMMENT 'xxxxxx' cascade;

在1.1.0中表和分区的元数据就是分开处理的，在增加字段的时候添加CASCADE能同时更新表和分区 对于，在添加字段的时候没有指定的cascade的情况

因为我们在重跑数据的时候，虽然HDFS上的数据更新了，但是我们查询的时候仍然查询的是旧的元数据信息（即Mysql中的信息）	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
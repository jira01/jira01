create table hive_table_01(
id int,
name string,
age int
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES("hbase.columns.mapping" = ":key,info:name,info:age")
TBLPROPERTIES("hbase.table.name" = "jira:hbase_table");



insert into table hive_hbase_table 
select 001,'zhangsan',18
union all 
select 002,'lisi',20
union all 
select 003,'wangwu',24
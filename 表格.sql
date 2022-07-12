student: /hive/warehouse/jira.db/student/xxx
#打开本地数据库连接
conn = MySQLdb.connect(host="localhost",user="root",passwd="123456",db="test",charset="utf8") 
#打开远程数据库连接
conn = MySQLdb.connect(host="xxx.xxx.xxx.xxx",port="3306",user="root",passwd="pwd",db="test",charset="utf8")

--表头字段
set hive.cli.print.header=true;

    val jdbc1: DataFrame = sqlC.jdbc("jdbc:mysql://nn2.hadoop:3306/表名?user=jira&password=12345678", "jira_web_seed")


--登录mysql
mysql -uroot -p'12345678'                            

--创建hive用户
CREATE USER 'hive'@'%' IDENTIFIED BY 'root';   
--在mysql中创建hive_meta数据库
create database hive_meta default charset utf8 collate utf8_general_ci;
--给hive用户增加hive_meta数据库权限
grant all privileges on hive_meta.* to 'hive'@'%' identified by 'root';

grant all privileges on *.* to root@'%' identified by "password";

--更新
flush privileges; 

修改数据库

ALTER (DATABASE|SCHEMA) database_name SET DBPROPERTIES (property_name=property_value, ...);

ALTER (DATABASE|SCHEMA) database_name SET OWNER [USER|ROLE] user_or_role; 

删除数据库

DROP (DATABASE|SCHEMA) [IF EXISTS] database_name [RESTRICT|CASCADE];

 



-- 建立索引 （给 user_install_status_limit(aid) 建个索引表，索引名称：index_aid  ）
create index index_aid on table user_install_status_limit(aid) as   'org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler' with deferred rebuild 
IN TABLE index_table_user;                                          
-- 更新索引数据
alter index index_aid on user_install_status_limit rebuild;     
--自动使用索引
SET hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;
-- 自动开启索引
SET hive.optimize.index.filter=true;
SET hive.optimize.index.filter.compact.minsize=0;
-- 查看索引
SHOW INDEX on user_install_status_limit;    
-- 删除索引
DROP INDEX index_aid on user_install_status_limit;  

--内表
CREATE TABLE `user_install_status_limit`(
  `aid` string, 
  `pkgname` string, 
  `uptime` bigint, 
  `type` int, 
  `country` string, 
  `gpcategory` string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
--外表
CREATE EXTERNAL TABLE ext_test(
word string, num int)
 COMMENT 'This is ext_testtable'
 ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
 STORED AS TEXTFILE
 LOCATION '/user/panniu/hive31/ext_test';
 
 
 -- name, age ,sex
--分区表
CREATE EXTERNAL TABLE student_par(
name string
)
PARTITIONED BY (age int,sex STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/user/jiazi/data/student_par';
	--添加partition
	alter table student_par add IF NOT EXISTS partition(age=10,sex='boy') location '10/boy';
	--再加两个分区
	alter table student_par add IF NOT EXISTS partition (age=11,sex='boy') location '11/boy' partition (age=11,sex='girl') location '11/girl';


--avro表
{
	"type": "record",
	"name": "RunRecord",
	"namespace": "com.jira",
	"fields": [{
			"name": "aid",
			"type": ["null", "string"],
			"default": null
		}, {
			"name": "pkgname",
			"type": ["null", "string"],
			"default": null
		}, {
			"name": "uptime",
			"type": "long",
            "default": -1
		}, {
			"name": "type",
			"type": "int",
            "default": -1
		}, {
			"name": "country",
			"type": ["null", "string"],
			"default": null
		}
	]
}

CREATE EXTERNAL TABLE IF NOT EXISTS word_avro
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
WITH SERDEPROPERTIES ('avro.schema.url'='/user/panniu/hive31/config/avro.schema')
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/panniu/hive31/word_avro';


--表中导入数据 
insert into table word_avro
select word, 100,num from ext_test;


--orc表
 CREATE EXTERNAL TABLE `user_install_status_other`(
`aid` string COMMENT 'from deserializer', 
`pkgname` string COMMENT 'from deserializer', 
`uptime` bigint COMMENT 'from deserializer', 
`type` int COMMENT 'from deserializer', 
`country` string COMMENT 'from deserializer', 
`gpcategory` string COMMENT 'from deserializer')
PARTITIONED BY (`dt` string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION 'hdfs://ns1/user/panniu/user_install_status_other'
TBLPROPERTIES ('orc.compress'='SNAPPY', 'orc.create.index'='true');
--导入数据后，可以通过hive 命令分析orc文件
hive --orcfiledump orc文件对应的hdfs目录


--建partition 分区
alter table user_install_status_other add if not exists partition (dt='20141228') location '20141228';
--给分区插入数据
insert overwrite table user_install_status_other partition(dt='20141228')
select
aid,
pkgname,
uptime,
type,
country,
gpcategory
from panniu.user_install_status
where dt='20141228';

--改表名
ALTER TABLE table_name RENAME TO new_table_name;

--内部表修改表名
ALTER TABLE user_info RENAME TO user_info_2;

--外部表修改表名
alter table ext_test rename to ext_test_2;

-- 内部表删除分区
alter table inner_task DROP IF EXISTS partition(taskname='sortword');
--内部表修改分区路径
alter table inner_task PARTITION  (taskname='wordcount') set location "hdfs://ns1/hive/warehouse/c31pan.db/inner_task/wordcount1";
-- 1）先设置压缩
--设置hive输出压缩
set hive.exec.compress.output=true;
set mapred.output.compress=true; 
set mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec; 
set io.compression.codecs=org.apache.hadoop.io.compress.GzipCodec; 
--2）通过表向表中导入数据
insert overwrite table user_install_status_gz
select
aid,
pkgname,
uptime,
type,
country,
gpcategory
from panniu.user_install_status
where dt='20141228'; 
--创建外部表桶表,桶的数量
CREATE EXTERNAL TABLE user_install_status_buckets(
`aid` string, 
`pkgname` string, 
`uptime` bigint, 
`type` int, 
`country` string, 
`gpcategory` string)
COMMENT 'This is the buckets_table table'
PARTITIONED BY (`dt` string)
CLUSTERED BY(country) SORTED BY(uptime desc) INTO 42 BUCKETS
LOCATION 'hdfs://ns1/user/panniu/hive26/user_install_status_buckets';
--桶表抽样
select * from buckets_table tablesample(bucket 11 out of 42 on country)

--创建内部表inner_test1
create table inner_test1 stored as orc as
select word,num from word_table;


--表中导入文件
load data local INPATH '/home/jzw31/upload/country_dict.txt' overwrite into table country_dict; 
可以直接是文件，也可以是目录
--filepath： 不能有子目录
--OVERWRITE： 有：覆盖导入， 没有：追加导入
-- 查询ext_task 表中分区为wordcount 的数据，以AVRO 格式写入到hdfs指定目录
insert overwrite local directory '/home/jzw31/upload/' STORED AS AVRO
select word, num from ext_task where taskname='wordcount01';


--设置参数动态分区
--开启动态分区
set hive.exec.dynamic.partition=true;  
--这个属性默认是strict，即限制模式，strict是避免全分区字段是动态的，必须至少一个分区字段是指定有值即静态的，且必
--须放在最前面。设置为nonstrict之后所有的分区都可以是动态的了。
set hive.exec.dynamic.partition.mode=nonstrict;
------------------------------------------------------------------------
--表示每个节点生成动态分区的最大个数，默认是100
set hive.exec.max.dynamic.partitions.pernode=10000;  

--表示一个DML操作可以创建的最大动态分区数，默认是1000
set hive.exec.max.dynamic.partitions=100000;

--表示一个DML操作可以创建的最大文件数，默认是100000
set hive.exec.max.created.files=150000

--将select数据，覆盖到表的动态分区
insert overwrite table table1 partition (ds, hr)  
select key, value, ds, hr FROM table2 WHERE ds is not null;



-- 关闭mapjon
set hive.auto.convert.join=false;
set hive.ignore.mapjoin.hint=false;
select * from test_a a inner join test_b b on a.id=b.id;

--当带有union 的时候， 多个结果集join，需要把字段写清楚，否则union 的时候，得到的数据超乎你的想象。
select a.id as aid, a.name as aname, b.id as bid, b.name as bname from test_a a left join test_b b on a.id = b.id
union
select a.id as aid, a.name as aname, b.id as bid, b.name as bname from test_a a right join test_b b on a.id = b.id;
--增加reducer任务数量
set mapred.reduce.tasks=20;

--在同一个sql中的不同的job是否可以同时运行,默认为false
set hive.exec.parallel=true;

--增加同一个sql允许并行任务的最大线程数
set hive.exec.parallel.thread.number=8;

--设置reducer内存大小
set mapreduce.reduce.memory.mb=4096;
set mapreduce.reduce.java.opts=-Xmx3584m;
--在设置成false 或 true时，可以手动的mapjoin设置
select /*+ MAPJOIN(c) */ * from panniu.user_install_status u
inner join country_dict c
on u.country=c.code
where u.dt='20141228'
limit 10;

-- 前无限行到当前行
rows between unbounded preceding and current row
-- 前2 行到当前行
rows between 2 preceding and current row
-- 当前行到后2行
rows between current row and 2 following
-- 前无限行到后无限行
rows between unbounded preceding and unbounded following

-- 在本地创建hive用户
CREATE USER 'hive'@'%' IDENTIFIED BY '12345678'; 
-- 在本地创建 hive_meta 库
create database hive_meta default charset utf8 collate utf8_general_ci;
-- 赋权限
grant all privileges on hive_meta.* to 'hive'@'%' identified by '12345678';
flush privileges; 

-- 加载自定义函数
CREATE TEMPORARY FUNCTION code2name AS 'com.jiazi.function.CountryCode2CountryNameUDF'; 
--使用自定义函数
select country,code2name(country) as name  from user_inner limit 10;

-- 首先table_name表每行调用udtf_func，会把一行拆分成一或者多行
-- 再把结果组合，产生一个支持别名表tableAlias的虚拟表
select table_name.id, tableAlias.col1, tableAlias.col2 
from table_name 
lateral view udtf_func(properties) tableAlias as col1,col2;

select t1.id, t2.name, t2.nickname 
from udtf_table t1
lateral view udtf_split(name_nickname) t2 as name,nickname;



select count(1) from (select aid from user_install_status where da='20121117' group by aid)a
	right join 
	(select aid from user_install_status where da="20121118" group by aid)b
	on a.aid = b.aid
	where a.aid is null;








































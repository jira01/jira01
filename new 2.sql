create 'jiazi:dm_shop_all_active_users','cf'

CREATE EXTERNAL TABLE `dm_shop_all_active_users`(
  `ip` bigint COMMENT 'from deserializer', 
  `area` string COMMENT 'from deserializer', 
  `time` bigint COMMENT 'from deserializer', 
  `request_day` string COMMENT 'from deserializer', 
  `requesttype` string COMMENT 'from deserializer', 
  `requesturl` string COMMENT 'from deserializer', 
  `ua_type` string COMMENT 'from deserializer', 
  `cookie` string COMMENT 'from deserializer', 
  `logonname` string COMMENT 'from deserializer')
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  'hdfs://ns1/data/hainiu/hainiu_shop_offline/dm_shop_all_active_users'
TBLPROPERTIES (
  'numFiles'='1', 
  'totalSize'='115782', 
  'transient_lastDdlTime'='1625296983')
  
  dm_shop_active_users
  OK
ip                      bigint                  from deserializer   
area                    string                  from deserializer   
time                    bigint                  from deserializer   
request_day             string                  from deserializer   
requesttype             string                  from deserializer   
requesturl              string                  from deserializer   
ua_type                 string                  from deserializer   
cookie                  string                  from deserializer   
logonname               string                  from deserializer   
year                    string                                      
day                     string                                      
                 
# Partition Information          
# col_name              data_type               comment             
                 
year                    string                                      
day                     string                                      
Time taken: 0.216 seconds, Fetched: 17 row(s)
     dm_shop_all_active_users;
OK
ip                      bigint                  from deserializer   
area                    string                  from deserializer   
time                    bigint                  from deserializer   
request_day             string                  from deserializer   
requesttype             string                  from deserializer   
requesturl              string                  from deserializer   
ua_type                 string                  from deserializer   
cookie                  string                  from deserializer   
logonname               string                  from deserializer   


select * from dm_shop_active_users where request_day=date_sub(request_day,1) limit 100;


select * from dm_shop_active_users where time=time-1 limit 100;


select * from dm_shop_active_users limit 100;

select * from dm_shop_active_users where request_day='request_day-1' limit 100;


select date_format('2021-07-02','yyyy-MM-dd');


select date_format(current_date(),'yyyyMMdd');

select from_unixtime(unix_timestamp('20180905','yyyymmdd'),'yyyy-mm-dd')

select * from dm_shop_all_active_users where request_day=request_day-1 limit 100;

select * from dm_shop_all_active_users where request_day=date_format(date_sub(current_date(),2),'yyyyMMdd') limit 100;

select date_format(date_sub(current_date(),2),'yyyyMMdd');

select count(1) from 



select * from 
(select * from dm_shop_all_active_users where request_day=date_format(date_sub(current_date(),3),'yyyyMMdd')) t1
right join 
(select * from dm_shop_active_users where request_day=date_format(date_sub(current_date(),2),'yyyyMMdd')) t2 
on t1.requesttype=t2.requesttype 
where t1.cookie is null;

select distinct cookie from dm_shop_active_users where request_day=date_format(date_sub(current_date(),1),'yyyyMMdd')

dm_shop_active_users

dm_shop_all_active_users

select count(*) from 
dm_shop_active_users;

select count(*) from 
dm_shop_all_active_users;


select count(*) from dm_shop_active_users where request_day=date_format(date_sub(current_date(),2),'yyyyMMdd')
select count(*) from dm_shop_all_active_users where request_day=date_format(date_sub(current_date(),3),'yyyyMMdd')

create 'jiazi:dm_shop_all_active_users','cf'

hadoop jar orc2hfilepro -Dtask.id=jiazi_0704 -Dtask.base.dir=/tmp/hbase -Dtask.input.dir=/tmp/hbase/input -Dhbase.table.name=jiazi:dm_shop_all_active_users -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1


hadoop jar hbase-1.0-hainiu.jar orc2hfilepro -Dtask.id=jiazi_0704 -Dtask.base.dir=/user/jiazi/hbase -Dtask.input.dir=/user/jiazi/hbase/orc2hfilepro/input -Dhbase.table.name=jiazi:dm_shop_all_active_users -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1


hadoop jar /usr/local/hbase/lib/hbase-shell-1.3.1.jar completebulkload /user/jiazi/hbase/data jiazi:user_hbase

CREATE EXTERNAL TABLE `dm_shop_all_active_users`(
  `ip` bigint COMMENT 'from deserializer', 
  `area` string COMMENT 'from deserializer', 
  `time` bigint COMMENT 'from deserializer', 
  `request_day` string COMMENT 'from deserializer', 
  `requesttype` string COMMENT 'from deserializer', 
  `requesturl` string COMMENT 'from deserializer', 
  `ua_type` string COMMENT 'from deserializer', 
  `cookie` string COMMENT 'from deserializer', 
  `logonname` string COMMENT 'from deserializer')
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  'hdfs://ns1/user/jiazi/hive/dm_shop_all_active_users'
  
  
  select null,time_local,brand_id,brand_cname,brand_ename,area,req_source_type,ua_type,click_num,date_format(current_timestamp(), 'yyyy-MM-dd') as create_day from
(select count(1) as click_num,request_day as time_local,brand_id,area,req_source_type,ua_type from dm_shop_brand_click where request_day='20210617' 
group by  request_day,area,ua_type,req_source_type,brand_id 
grouping sets((brand_id,area,ua_type,req_source_type),(brand_id,area,ua_type),(brand_id,ua_type,req_source_type),(brand_id,req_source_type,area),()))as t1
left join 
(select id ,brand_cname,brand_ename from dm_shop_brand_entity) as t2
on t1.brand_id=t2.id
  
  
  
select count(1) as click_num,request_day as time_local,brand_id,area,req_source_type,ua_type from dm_shop_brand_click where request_day='20210617' 
group by  request_day,area,ua_type,req_source_type,brand_id 
grouping sets((brand_id,area,ua_type,req_source_type)),(brand_id,area,ua_type),(brand_id,ua_type,req_source_type),(brand_id,req_source_type,area),()))
  
  
  
 snapshot 'jiazi:dm_shop_all_active_users', 'jiazi_dm_shop_all_active_users_snapshot'
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  



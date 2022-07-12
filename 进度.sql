

dm_shop_goods_click          

dm_shop_goods_show

dm_shop_goods_entity



CREATE TABLE `jiazi_ads_shop_goods_clickrate` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `goodsid` varchar(30) NOT NULL COMMENT '商品id',
  `goods_cname` varchar(256) DEFAULT '' COMMENT '商品中文名称',
  `goods_ename` varchar(256) DEFAULT '' COMMENT '商品英文名称',
  `show_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '展示数',
  `click_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '点击数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3488 DEFAULT CHARSET=utf8;


select null,t.d1,t.id1,t3.c,t3.e, t.num2,t.num1,date_format(current_timestamp(),'yyyyMMdd') from 
(select id1 ,num1,num2,d1 from
(select count(1) as num1, goods_id as id1,request_day d1 from dm_shop_goods_click group by goods_id,request_day) t1
right join
(select count(1) as num2 ,goodsid as id2 ,request_day d2 from dm_shop_goods_show group by goodsid,request_day) t2
on t1.id1=t2.id2 and t1.d1=t2.d2) t
left join
(select id as id3 ,goods_cname as c,goods_ename as e from dm_shop_goods_entity) t3
on t.id1=t3.id3 where d1=date_format(current_timestamp(),'yyyyMMdd')-1;


hive -e "use panniu;select null,t.d1,t.id1,t3.c,t3.e, t.num2,t.num1,date_format(current_timestamp(),'yyyyMMdd') from 
(select id1 ,num1,num2,d1 from
(select count(1) as num1, goods_id as id1,request_day d1 from dm_shop_goods_click group by goods_id,request_day) t1
right join
(select count(1) as num2 ,goodsid as id2 ,request_day d2 from dm_shop_goods_show group by goodsid,request_day) t2
on t1.id1=t2.id2 and t1.d1=t2.d2) t
left join
(select id as id3 ,goods_cname as c,goods_ename as e from dm_shop_goods_entity) t3
on t.id1=t3.id3 where d1=date_format(current_timestamp(),'yyyyMMdd')-1;;" > jiazi_ads_shop_goods_clickrate






CREATE TABLE `jiazi_ads_shop_goods_buy_clickrate` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `goodsid` varchar(30) NOT NULL COMMENT '商品id',
  `goods_cname` varchar(256) DEFAULT '' COMMENT '商品中文名称',
  `goods_ename` varchar(256) DEFAULT '' COMMENT '商品英文名称',
  `click_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '点击数',
  `buy_click_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '购买点击数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=868 DEFAULT CHARSET=utf8;


dm_shop_goods_click 
dm_shop_goods_buy_click	
dm_shop_goods_entity


select  null ,d2, id2 , dcname , dename, num2 , num1 , date_format(current_timestamp(), 'yyyy-MM-dd') as d from
(select id1 , id2 , num2 , num1 ,d2 from 
(select count(goods_id) as num1, goods_id as id1,request_day as d1 from dm_shop_goods_click group by request_day,goods_id) as dc left join
(select count(1) as num2 , goods_id as id2 ,request_day as d2 from dm_shop_goods_buy_click group by request_day,goods_id )as ds on dc.id1 = ds.id2 and dc.d1=ds.d2) dd
left join (select id as id3 , goods_cname as dcname ,goods_ename as dename from dm_shop_goods_entity )as de
on dd.id2 = de.id3 where d2=date_format(current_timestamp(), 'yyyyMMdd')-1;


select null,t.d1,t.id1,t3.c,t3.e, t.num1,t.num2,date_format(current_timestamp(),'yyyyMMdd') from 
(select id1 ,num1,num2,d1 from
(select count(1) as num1, goods_id as id1,request_day d1 from dm_shop_goods_click group by goods_id,request_day) t1
left join
(select count(1) as num2 ,goods_id as id2 ,request_day d2 from dm_shop_goods_buy_click group by goods_id,request_day) t2
on t1.id1=t2.id2 and t1.d1=t2.d2) t
left join
(select id as id3 ,goods_cname as c,goods_ename as e from dm_shop_goods_entity) t3
on t.id1=t3.id3 where d1=date_format(current_timestamp(),'yyyyMMdd')-1;


hive -e "use panniu;select null,t.d1,t.id1,t3.c,t3.e, t.num1,t.num2,date_format(current_timestamp(),'yyyyMMdd') from 
(select id1 ,num1,num2,d1 from
(select count(1) as num1, goods_id as id1,request_day d1 from dm_shop_goods_click group by goods_id,request_day) t1
left join
(select count(1) as num2 ,goods_id as id2 ,request_day d2 from dm_shop_goods_buy_click group by goods_id,request_day) t2
on t1.id1=t2.id2 and t1.d1=t2.d2) t
left join
(select id as id3 ,goods_cname as c,goods_ename as e from dm_shop_goods_entity) t3
on t.id1=t3.id3 where d1=date_format(current_timestamp(),'yyyyMMdd')-1;" > jiazi_ads_shop_goods_buy_clickrate

[jzw31@op shell]$ vim import_mysql.sh 
mysqlDBUrl="/bin/mysql -hnn2.hadoop -p3306 -uhainiu -p12345678 -Dhainiutest"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "/home/jzw31/jiazi_ads_shop_goods_buy_clickrate" INTO TABLE jiazi_ads_shop_goods_buy_clickrate FIELDS TERMINATED BY '\t';
EOF





CREATE TABLE `ads_shop_brand_clicktop` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `brand_id` varchar(30) NOT NULL COMMENT '品牌id',
  `brand_cname` varchar(256) DEFAULT '' COMMENT '品牌中文名称',
  `brand_ename` varchar(256) DEFAULT '' COMMENT '品牌英文名称',
  `area` varchar(256) DEFAULT '' COMMENT '点击地区',
  `req_source_type` varchar(256) DEFAULT '' COMMENT '点击来源',
  `ua_type` varchar(256) DEFAULT '' COMMENT '浏览器类型',
  `click_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '点击数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8;


dm_shop_goods_click 
dm_shop_goods_entity


area
req_source_type
ua_type
select request_day,id,goods_cname,goods_ename,area,req_source_type, ua_type ,count(*) from dm_shop_goods_click as t1
left join dm_shop_goods_entity as t2
on t1.goods_id=t2.id;



select null,date_sub(current_date(),1),id1,goods_cname,goods_ename,area,tp1,tp2,num,current_date() from 
(select goods_id id1,area,req_source_type tp1,ua_type tp2 ,count(*) num 
from dm_shop_goods_click where request_day=date_format(current_date,'yyyyMMdd')-1 group by goods_id,area,req_source_type, ua_type grouping sets((goods_id),(goods_id,area),(goods_id,area,req_source_type),(goods_id,area,req_source_type,ua_type)))t1
left join dm_shop_goods_entity t
on t.id=t1.id1;


hive -e "use panniu;select null,date_sub(current_date(),1),id1,goods_cname,goods_ename,area,tp1,tp2,num,current_date() from 
(select goods_id id1,area,req_source_type tp1,ua_type tp2 ,count(*) num 
from dm_shop_goods_click where request_day=date_format(current_date,'yyyyMMdd')-1 group by goods_id,area,req_source_type, ua_type grouping sets((goods_id),(goods_id,area),(goods_id,area,req_source_type),(goods_id,area,req_source_type,ua_type)))t1
left join dm_shop_goods_entity t
on t.id=t1.id1;" > jiazi_ads_shop_goods_clicktop


[jzw31@op shell]$ vim import_mysql.sh 
mysqlDBUrl="/bin/mysql -hnn2.hadoop -p3306 -uhainiu -p12345678 -Dhainiutest"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "/home/jzw31/jiazi_ads_shop_goods_clicktop" INTO TABLE jiazi_ads_shop_goods_clicktop FIELDS TERMINATED BY '\t';
EOF



select goods_id id ,count(*) num from dm_shop_goods_click where request_day=date_format(current_timestamp(),'yyyyMMdd')-1 group by goods_id order by num ;



select date_sub(current_date(),1) from dm_shop_goods_click limit 10;


CREATE TABLE `jiazi_ads_shop_brand_clicktop` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `brand_id` varchar(30) NOT NULL COMMENT '品牌id',
  `brand_cname` varchar(256) DEFAULT '' COMMENT '品牌中文名称',
  `brand_ename` varchar(256) DEFAULT '' COMMENT '品牌英文名称',
  `area` varchar(256) DEFAULT '' COMMENT '点击地区',
  `req_source_type` varchar(256) DEFAULT '' COMMENT '点击来源',
  `ua_type` varchar(256) DEFAULT '' COMMENT '浏览器类型',
  `click_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '点击数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8;

dm_shop_brand_click

dm_shop_brand_entity
   `ip` bigint COMMENT 'from deserializer', 
  `area` string COMMENT 'from deserializer', 
  `time` bigint COMMENT 'from deserializer', 
  `request_day` string COMMENT 'from deserializer', 
  `requesttype` string COMMENT 'from deserializer', 
  `requesturl` string COMMENT 'from deserializer', 
  `brand_id` int COMMENT 'from deserializer', 
  `req_source_type` string COMMENT 'from deserializer', 
  `ua_type` string COMMENT 'from deserializer', 
  `cookie` string COMMENT 'from deserializer', 
  `logonname`


select null,date_sub(current_date(),1),id1,brand_cname,brand_ename,area,tp1,tp2,num,current_date() from 
(select brand_id id1,area,req_source_type tp1,ua_type tp2 ,count(*) num 
from dm_shop_brand_click where request_day=date_format(current_date(),'yyyyMMdd')-1 group by brand_id,area,req_source_type, ua_type grouping sets((brand_id),(brand_id,area),(brand_id,area,req_source_type),(brand_id,area,req_source_type,ua_type)))t1
left join dm_shop_brand_entity t
on t.id=t1.id1;


hive -e "use panniu;select null,date_sub(current_date(),1),id1,brand_cname,brand_ename,area,tp1,tp2,num,current_date() from 
(select brand_id id1,area,req_source_type tp1,ua_type tp2 ,count(*) num 
from dm_shop_brand_click where request_day=date_format(current_date(),'yyyyMMdd')-1 group by brand_id,area,req_source_type, ua_type grouping sets((brand_id),(brand_id,area),(brand_id,area,req_source_type),(brand_id,area,req_source_type,ua_type)))t1
left join dm_shop_brand_entity t
on t.id=t1.id1;" > jiazi_ads_shop_brand_clicktop

[jzw31@op shell]$ vim import_mysql.sh 
mysqlDBUrl="/bin/mysql -hnn2.hadoop -p3306 -uhainiu -p12345678 -Dhainiutest"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "/home/jzw31/jiazi_ads_shop_brand_clicktop" INTO TABLE jiazi_ads_shop_brand_clicktop FIELDS TERMINATED BY '\t';
EOF





dm_shop_goods_show

dm_shop_goods_relate_entity

  `goodsid` int COMMENT 'from deserializer', 
  `brandid` int COMMENT 'from deserializer', 
  `goods_type_small_id` varchar(20) COMMENT 'from deserializer', 
  `goods_type_big_id`


`requestactiontime` bigint COMMENT 'from deserializer', 
  `request_day` string COMMENT 'from deserializer', 
  `requestactionurl` string COMMENT 'from deserializer', 
  `source_type` string COMMENT 'from deserializer', 
  `goodsid` int COMMENT 'from deserializer', 
  `goodssn` string COMMENT 'from deserializer', 
  `goodstypeid` string COMMENT 'from deserializer', 
  `brandid` int COMMENT 'from deserializer', 
  `ip` bigint COMMENT 'from deserializer', 
  `area` string COMMENT 'from deserializer', 
  `cookie` string COMMENT 'from deserializer', 
  `logonname`



CREATE TABLE `jiazi_ads_shop_goods_pvuviv` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `goods_type_big_id` varchar(30) DEFAULT '' COMMENT '商品类别',
  `area` varchar(256) DEFAULT '' COMMENT '地区',
  `uv` bigint(20) NOT NULL DEFAULT '0' COMMENT '网站用户流量',
  `iv` bigint(20) NOT NULL DEFAULT '0' COMMENT '网站ip流量',
  `pv` bigint(20) NOT NULL DEFAULT '0' COMMENT '网站流量',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;






select null,date_sub(current_date(),2),goods_type_big_id,area,count(distinct ip) iv,count(distinct cookie),count(*) pv,current_date()from 
(select * from 
(select * from dm_shop_goods_show  where request_day=date_format(current_date(),'yyyyMMdd')-2) t1
left join dm_shop_goods_relate_entity t2 on t1.goodsid=t2.goodsid) t
group by goods_type_big_id,area grouping sets ((),(goods_type_big_id),(area),(goods_type_big_id,area));



hive -e "use panniu;select null,date_sub(current_date(),2),goods_type_big_id,area,count(distinct ip) iv,count(distinct cookie),count(*) pv,current_date()from 
(select * from 
(select * from dm_shop_goods_show  where request_day=date_format(current_date(),'yyyyMMdd')-2) t1
left join dm_shop_goods_relate_entity t2 on t1.goodsid=t2.goodsid) t
group by goods_type_big_id,area grouping sets ((),(goods_type_big_id),(area),(goods_type_big_id,area));" > jiazi_ads_shop_goods_pvuviv



dm_shop_brand_click
dm_shop_goods_relate_entity


select null,date_sub(current_date(),2),goods_type_big_id,area,count(distinct cookie) uv,count(distinct ip) iv,count(*) pv,current_date()from 
(select * from 
(select * from dm_shop_brand_click  where request_day=date_format(current_date(),'yyyyMMdd')-2) t1
left join dm_shop_goods_relate_entity t2 on t1.brand_id=t2.brandid) t
group by goods_type_big_id,area grouping sets ((),(goods_type_big_id),(area),(goods_type_big_id,area));



hive -e "use panniu;select null,date_sub(current_date(),2),goods_type_big_id,area,count(distinct ip) iv,count(distinct cookie),count(*) pv,current_date()from 
(select * from 
(select * from dm_shop_brand_click  where request_day=date_format(current_date(),'yyyyMMdd')-2) t1
left join dm_shop_goods_relate_entity t2 on t1.brand_id=t2.brandid) t
group by goods_type_big_id,area grouping sets ((),(goods_type_big_id),(area),(goods_type_big_id,area));" > jiazi_ads_shop_brand_pvuviv


select substring(current_date())
select 
(select  *,
row_number() over(partition by cookie order by time desc )
from dws_shop_click where `year`=2021 and `day`=0618)
;

dm_shop_active_users


CREATE TABLE `jiazi_ads_shop_daily_active_users` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '日活用户数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

select null,concat(date_sub(current_date(),31),'到',date_sub(current_date(),1)) date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by `time` desc ) rn
from dm_shop_active_users where request_day=date_format(current_date(),'yyyyMMdd')-2) t



select null,date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by time` desc ) rn
from dm_shop_active_users where request_day=date_format(current_date(),'yyyyMMdd')-2) t;



hive -e "use panniu;select null,date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by `time` desc ) rn
from dm_shop_active_users where request_day=date_format(current_date(),'yyyyMMdd')-2) t;" > jiazi_ads_shop_daily_active_users


hive -e "use panniu;select null,date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by `time` desc ) rn
from dm_shop_active_users where request_day=date_format(current_date(),'yyyyMMdd')-2) t;" > jiazi_ads_shop_daily_active_users






hive -e "use panniu;select null,date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by time desc ) rn
from dm_shop_active_users where request_day=date_format(current_date(),'yyyyMMdd')-2) t;" > jiazi_ads_shop_daily_active_users




CREATE TABLE `jiazi_ads_shop_monthly_active_users` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '业务日期前30天活跃用户数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;


dm_shop_monthly_active_users

select null,date_sub(current_date(),2),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by time desc ) rn
from dm_shop_monthly_active_users where request_day>=date_format(add_months(current_date(),-1),'yyyyMMdd') and request_day<date_format(current_date(),'yyyyMMdd')) t;










select date_format(add_months(current_date(),-1),'yyMMdd');





select *,
row_number() over(partition by cookie order by time desc ) rn
from dm_shop_monthly_active_users where request_day=date_format((date_sub(current_date(),2)),'yyMMdd');


select date_sub(current_date(),)



select null,concat (date_sub(add_months(current_date(),-1),1),'-------',date_sub(current_date(),1)),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by time desc ) rn
from dm_shop_monthly_active_users where request_day>=date_format(add_months(current_date(),-1),'yyyyMMdd') and request_day<date_format(current_date(),'yyyyMMdd')) t;


hive -e "use panniu;select null,concat (date_sub(add_months(current_date(),-1),1),'-------',date_sub(current_date(),1)),count(distinct cookie),current_date() from 
(select *,
row_number() over(partition by cookie order by time desc ) rn
from dm_shop_monthly_active_users where request_day>=date_format(add_months(current_date(),-1),'yyyyMMdd')-1 and request_day<date_format(current_date(),'yyyyMMdd')-1) t;" > jiazi_ads_shop_monthly_active_users

concat (date_sub(add_months(current_date(),-1),1),'-------',date_sub(current_date(),1))


CREATE TABLE `jiazi_ads_shop_monthly_active_users` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time_local` varchar(30) NOT NULL COMMENT '业务日期',
  `user_num` bigint(20) NOT NULL DEFAULT '0' COMMENT '业务日期前30天活跃用户数',
  `create_day` varchar(30) NOT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;



select null, CONCAT(date_sub(date_format(current_timestamp(), 'yyyy-MM-dd'),30),'到', date_format(current_timestamp(), 'yyyy-MM-dd')),count(distinct cookie),date_format(current_timestamp(),'yyyyMMdd')
 from
(select request_day,cookie ,row_number() over(partition by cookie order by  request_day desc )as n
from dm_shop_monthly_active_users
 where 
 request_day >=(date_format(current_timestamp(),'yyyyMMdd'))-30 and 
request_day <= (date_format(current_timestamp(),'yyyyMMdd')))t1 where t1.n =1; 



[jzw31@op shell]$ vim import_mysql.sh 
mysqlDBUrl="/bin/mysql -hnn1.hadoop -p3306 -udb_user -proot -Ddb_base"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "/home/hadoop/country_dict/country_dict.txt" INTO TABLE country_dict FIELDS TERMINATED BY '\t';
EOF



CREATE TABLE `country_dict`(
  `country` string, 
  `chinese` string, 
  `english` string, 
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE `country_dict` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `country` varchar(30) ,
  `chinese` varchar(500) ,
  `english` varchar(30) ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;











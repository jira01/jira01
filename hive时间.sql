-- hive 上日期减去几个月
 select add_months('2015-02-01',-2);
-- 如果想返回当用的第一天
select add_months(trunc('2015-02-01','MM'),-2);
 
 -- 加一天减一天
select date_sub(current_date(),1)
select date_add(current_date(),1)

--当前日期格式化
select date_format(current_date(),'yyyy-MM-dd HH:mm:ss');
--当前时间格式化
select date_format(current_timestamp(), 'yyyy-MM-dd HH:mm:ss');

--获取当前timestamp的Unix时间戳
select unix_timestamp(current_timestamp);
--转换成指定格式的字符串
select from_unixtime(1530755469, "yyyy-MM-dd");

1.日期增加函数
date_add语法: date_add(string startdate, intdays) 
返回值: string 
说明: 返回开始日期startdate增加days天后的日期。
2.日期减少函数
date_sub语法: date_sub (string startdate,int days) 
返回值: string 
说明: 返回开始日期startdate减少days天后的日期。

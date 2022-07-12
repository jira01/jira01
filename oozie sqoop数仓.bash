#启动Nginx
./sbin/nginx
#查看Nginx进程
ps -aux | grep nginx
#查看主进程号
cat /var/run/nginx.pid 
#如果修改了配置文件可以通过下面这个命令进行热加载
./sbin/nginx -s reload

#-e: refer

#-A: useragent

curl -s -o /dev/null -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11" -e "www.baidu.com" "nn1.hadoop?name=haha&age=10"


强制停止 : kill -9 nginx master进程和work进程
批量停止 : pkill nginx 

flume-ng  agent -n a1  -c ../conf  -f ../conf/netcat.conf   -Dflume.root.logger=DEBUG,console

flume-ng  agent -n a1  -c ../conf  -f ../conf/exec.conf   -Dflume.root.logger=DEBUG,console
flume-ng  agent -n a1  -c ../conf  -f ../conf/taildir.conf   -Dflume.root.logger=DEBUG,console

flume-ng  agent -n a1  -c ../conf  -f ../conf/spooling.conf   -Dflume.root.logger=DEBUG,console

kill -usr1 进程号   结束写入，重新生成新的文件写入

flume-ng  agent -n a1  -c ../conf  -f ../conf/taildir_access.conf   -Dflume.root.logger=DEBUG,console

# -x 是调试用的，加了这个，就会把脚本中的每条命令的执行情况打印出来
sh -x .sh 


# 执行shell 任务
oozie job -config ~/examples/apps/shell/job.properties -run
#查看任务
oozie job -info 进程号
#kill 掉任务
oozie job -kill 任务号

# 重启ssh
service sshd restart

# 制作导入数据的脚本并进行本地测试
其中：
    -h：mysql对应的hostname
    -P：mysql的端口号，也可以用-p
    -u：mysql的用户名
    -p：mysql用户名对应的密码
    -D：要导入的mysql数据库
[jzw31@op shell]$ vim import_mysql.sh 
mysqlDBUrl="/bin/mysql -hnn2.hadoop -p3306 -ujira -p12345678 -Djiratest"
${mysqlDBUrl} <<EOF
LOAD DATA LOCAL INFILE "/home/jzw31/aaa" INTO TABLE jzw31_ads_shop_goods_clickrate FIELDS TERMINATED BY '\t';
EOF

#从mysql导出数据

mysqlDBUrl="/bin/mysql -hnn1.hadoop -P3306 -u用户 -p密码 -D数据库 -q -N -e"

$msqlDBUrl "select * from tableName;" >> /data/out.mysql




# crontab 命令格式：
crontab -u <-l, -r, -e>
其中：
        -u：指定一个用户
        -l：列出某个用户的任务计划
        -r：删除某个用户的任务
        -e：编辑某个用户的任务
示例：
1）编辑用户任务调度
#用root用户编辑hadoop用户的任务调度
crontab -u hadoop -e
#用hadoop 用户编辑自己的任务的调度
crontab -e
# 查看任务是否执行
tail -f /var/log/cron
# 查看任务列表
cd /var/spool/cron
# 由于Cron 是linux的内置服务，可以用以下的方法启动、关闭这个服务:

#启动服务
service crond start 
#关闭服务
service crond stop
#重启服务
service crond restart
#重新载入服务
service crond reload

# -- 在mysql里执行  在sql里上传sql文件
use report;
# -- report3.sql 上传的SQL文件
source /root/report/report3.sql

# -- 导出到linux本地
hive -e "use jira;select COALESCE(remote_ip, 'ALL'), COALESCE(substring(time_local,1,8),'ALL'), count(*) from nginx_log group by remote_ip, substring(time_local,1,8) with cube;" 1>/home/hadoop/report_test/export_data 2>/dev/null

# -- 在mysql中创建db_user用的数据库和db_user用户
CREATE USER 'db_user'@'%' IDENTIFIED BY 'root'; 
# -- 在mysql中创建db_base数据库
create database db_base default charset utf8 collate utf8_general_ci;
# --给db_user用户增加db_base数据库权限
grant all privileges on db_base.* to 'db_user'@'%' identified by 'root';
flush privileges; 




















sqoop
参数解释 ： 
sqoop list-databases ： 展示所有数据库
sqoop list-tables ： 展示连接数据库的所有表
sqoop list-databases --connect jdbc:mysql://localhost:3306/ --username sqoop --password root
sqoop list-tables --connect jdbc:mysql://nn1.hadoop:3306/sqoop_db --username sqoop --password root
# 查询数据是否存在
sqoop eval \
--connect jdbc:mysql://nn1.hadoop:3306/sqoop_db \
--username sqoop \
--password root \
--query "select * from goods_table limit 10"

# 查询全部数据导入HDFS
sqoop import \
--connect jdbc:mysql://nn1.hadoop:3306/sqoop_db"?useUnicode=true&characterEncoding=UTF-8" \
--username sqoop \
--password root \
--table goods_table \
--target-dir /user/hadoop/sqoop/data/goods_table \
--delete-target-dir \
--num-mappers 1 \
--fields-terminated-by "\001"

# 公司集群导入
sqoop import \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--target-dir /user/jiazi/sqoop/data/goods_2 \
--delete-target-dir \
--num-mappers 1 \
--fields-terminated-by "\001" \
--table jiazi_goods_table \
--where "goods_sn rlike '003$' and id < 10"

# 查询全部数据导入hive
sqoop import \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_goods_table \
--num-mappers 1 \
--delete-target-dir \
--hive-import \
--fields-terminated-by "\001" \
--hive-overwrite \
--hive-table jiazi.goods_table2


# 增量数据导入
# append 无条件追加，
sqoop import \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_goods_update_table \
--num-mappers 1 \
--target-dir /hive/warehouse/jiazi.db/goods_update_table \
--fields-terminated-by "\001" \
--incremental append \
--check-column id \
--last-value 1

# lastmodified方式，必须要加--append（追加）或者--merge-key（合并，一般填主键）
update jiazi_goods_update_table set goods_price=666 where id=1;

sqoop import \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_goods_update_table \
--num-mappers 1 \
--target-dir /hive/warehouse/jiazi.db/goods_update_table \
--fields-terminated-by "\001" \
--incremental lastmodified \
--check-column last_update_time \
--last-value '2020-11-11 11:00:00' \
--merge-key id

# sqoop导出（公司集群执行）是指从大数据集群（HDFS，HIVE，HBASE）向非大数据集群（RDBMS）中传输数据；
        # 使用export关键字。

# -- 创建导出MySQL的表
# -- 导出时，如果MySQL没有该表，会报错
create table jiazi_export_goods_table like jiazi_goods_table;

sqoop export \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_export_goods_table \
--num-mappers 1 \
--export-dir /hive/warehouse/jiazi.db/goods_table \
--input-fields-terminated-by "\001"

# HIVE 导出 ORC表数据到MySQL
-- 导出orc表数据到MySQL
sqoop export \
--connect jdbc:mysql://nn2.hadoop:3306/jiratest"?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_export_goods_table \
--num-mappers 1 \
--export-dir /hive/warehouse/jiazi.db/goods_table \
--input-fields-terminated-by "\001"

# 封装

vim goods_table_import1.opt
import
--connect
jdbc:mysql://nn2.hadoop:3306/jiratest?useUnicode=true&characterEncoding=UTF-8
--username
jira
--password
12345678
--table
jiazi_goods_table
--num-mappers
1
--hive-import
--fields-terminated-by
"\001"
--hive-overwrite
--hive-table
jiazi.goods_table2
# 执行导入数据操作
sqoop --options-file goods_table_import1.opt

[jzw31@op sqoop_test]$ vim sqoop_import.sh 
#! /bin/bash
# 加载环境变量
. /etc/profile

sqoop import \
--connect "jdbc:mysql://nn2.hadoop:3306/jiratest?useUnicode=true&characterEncoding=UTF-8" \
--username jira \
--password 12345678 \
--table jiazi_goods_table \
--num-mappers 1 \
--hive-import \
--fields-terminated-by "\001" \
--hive-overwrite \
--hive-table \
jiazi.goods_table3






















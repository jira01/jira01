create_namespace 'jiazi'
# 建表
create 'jiazi:user_info','cf'
# 查寻
scan 'jiazi:user_info'
# 如果想获取到之前的，需要指定时间戳查询
get 'jiazi:user_info','id01',{COLUMN=>'cf:name',TIMESTAMP=>1622637973998}
# -- 删除jira_table 表的 cf3 列族
alter 'panniu:jira_table',{NAME=>'cf3',METHOD=>'delete'}
# -- 查看表结构
describe 'panniu:jira_table'
# -- 创建表
create 'panniu:table1','cf1','cf2','cf3'

# 获取id17的 1616643095897 数据，此时查询不到
get 'c30pan:user_info','id17',{COLUMN=>'cf:name',TIMESTAMP=>1616643095897}

# --删除多个列族
alter 'panniu:table1', {NAME => 'cf3', METHOD => 'delete'},{NAME => 'cf2', METHOD => 'delete'}



# ==>把表设置为disable（下线）
	disable '表名'

# ==>drop表
	#先把表下线，再drop表
	disable '表名'
	drop '表名'
    
# ==>判断表是否存在
	exists '表名'
 
# ==>判断表是否下线
	is_disabled '表名'

# ==>判断表是否上线
	is_enabled '表名'
	
	
	
	 
# 查看hfile文件内容
hbase org.apache.hadoop.hbase.io.hfile.HFile -e -p -f hdfs上的file文件
# -e：Print keys
# -p：Print key/value pairs
# -f：指定hdfs上的file文件



select date_sub(current_date(),1)

select date_add(current_date(),1)



# major_compact 合并
major_compact 'c30pan:user_info'

# 手动拆分语法：
split 'jiazi:usr_info','id03'

# 带有行筛选的scan， [STARTROW, STOPROW) z表示包含03
scan 'panniu:jira_table', { STARTROW => 'id02', STOPROW => 'id03z'}

# --删除多个列族
alter 'panniu:table1', {NAME => 'cf3', METHOD => 'delete'},{NAME => 'cf2', METHOD => 'delete'}
# 删除整行
deleteall 'jiazi:user_table', 'id05'

# 调用的hbase jar中自带的统计行数的类。
hbase org.apache.hadoop.hbase.mapreduce.RowCounter 'jiazi:user_table'

 # 计数器操作
 incr 'panniu:jira_table','id11','cf1:cert_no',5
 #获取当前count的值
get_counter 'panniu:jira_table', 'id11', 'cf1:cert_no'

#修改设置版本，查询时，加上版本就可以查出来版本
alter 'panniu:jira_table',{ NAME =>'cf1', VERSIONS => 2 }

如何修改HBase表的压缩格式
1） disable 'panniu:user_hbase_split1'
2） alter 'panniu:user_hbase_split1', NAME => 'cf', COMPRESSION => 'snappy'
3）enable 'panniu:user_hbase_split1'
4）major_compact 'panniu:user_hbase_split1'

# -- 注意：要加上zookeeper连接参数
# -- orc转hfile  Windows上跑mapreduce，集群load到表里 公司集群配置
orc2hfile -Dtask.id=jiazi_0605 -Dtask.base.dir=/tmp/hbase -Dtask.input.dir=/tmp/hbase/input -Dhbase.table.name=jiazi:user_hbase -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1
# -- 虚拟机集群配置
orc2hfile -Dtask.id=jiazi_0605 -Dtask.base.dir=/tmp/hbase -Dtask.input.dir=/tmp/hbase/input -Dhbase.table.name=jiazi:user_hbase -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181

# -- 把/user/jiazi/hbase/data 目录数据load到 hbase表 user_hbase 里面
hadoop jar /usr/local/hbase/lib/hbase-shell-1.3.1.jar completebulkload /user/jiazi/hbase/data jiazi:user_hbase

输入目录： /user/jiazi/hbase/orc2hfile/input
输出根目录： /user/panniu/hbase
#window 打包上集群，在公司集群跑mapreduce，再load到表里
hadoop jar hbase-1.0-jira.jar orc2hfile -Dtask.id=jiazi_0606 -Dtask.base.dir=/user/jiazi/hbase -Dtask.input.dir=/user/jiazi/hbase/orc2hfile/input -Dhbase.table.name=jiazi:user_hbase -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1

hadoop jar /usr/local/hbase/lib/hbase-shell-1.3.1.jar completebulkload /user/jiazi/hbase/orc2hfile_jiazi_0606/ jiazi:user_hbase

#window 打包虚拟机集群，在虚拟机集群跑mapreduce，再load到表里
mapinput：/hbase/orc2hfile/input
mapoutput：/hbase
# -- 虚拟机集群配置
hadoop jar hbase-1.0-jira.jar orc2hfile -Dtask.id=jiazi_0606 -Dtask.base.dir=/hbase -Dtask.input.dir=/hbase/orc2hfile/input -Dhbase.table.name=jiazi:user_hbase -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181

hadoop jar /usr/local/hbase/lib/hbase-shell-1.3.1.jar completebulkload /hbase/orc2hfile_jiazi_0606 jiazi:user_hbase

# 预分region
create 'jiazi:user_hbase_split', 'cf', {SPLITS_FILE => '/home/jzw31/hbase_test/split_data'}


# 后台运行
nohup hive -e "use jiazi; select sub,count(*) num from (select substring(aid,1,1) sub from user_install_status where dt='20141228') t1 group by sub order by num desc; " 1> ~/hbase_split_1_1 2> /dev/null &

# 压缩 
 alter 'jiazi:user_hbase_split1', NAME => 'cf', COMPRESSION => 'snappy'
 
 
# 命令创建预分表
hbase org.apache.hadoop.hbase.util.RegionSplitter jiazi:user_hbase_split2 com.jiazi.hbase.TableRegionSplit -c 2 -f cf

#将命名创建预分表集成到orc2hfilejob内部
hadoop jar hbase-1.0-jira.jar orc2hfilewithsplit -Dcreate.table=true -Dtask.id=jiazi_0607 -Dtask.base.dir=/hbase -Dtask.input.dir=/hbase/orc2hfile/input -Dhbase.table.name=jiazi:user_hbase_split3 -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181


#scan hbase2orc java 公司集群上运行
scanhbase2orc -Dtask.id=jiazi_0608 -Dtask.base.dir=/tmp/hbase -Dhbase.table.name=jiazi:user_hbase_split -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1
#scan hbase2orc 公司集群上运行
hadoop jar hbase-1.0-jira.jar scanhbase2orc -Dtask.id=jiazi_0608 -Dtask.base.dir=/user/jiazi/hbase -Dhbase.table.name=jiazi:user_hbase_split -Dhbase.zookeeper.quorum=nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 -Dzookeeper.znode.parent=/hbase1

# 创建 Snapshot
snapshot 'jiazi:user_hbase', 'user_snapshot'
# 恢复快照，新增的数据就不在了   先下线 disable
restore_snapshot 'user_snapshot'
# 克隆快照   根据快照恢复出一个新表，恢复过程不涉及数据移动
clone_snapshot 'user_snapshot', 'user_hbase2'
#快照 hbase2orc java 公司集群上运行
snapshot2orc -Dhbase.table.snapshot.name=user_snapshot -Dhbase.table.snapshot.restore.path=/user/jiazi/hbase/restore1 -Dhbase.rootdir=/hbase -Dtask.id=jiazi_0608 -Dtask.base.dir=/user/jiazi/hbase/output1

#快照 hbase2orc  在公司集群上运行
hadoop jar hbase-1.0-jira.jar snapshot2orc -Dhbase.table.snapshot.name=user_snapshot -Dhbase.table.snapshot.restore.path=/user/jiazi/hbase/restore2 -Dhbase.rootdir=/hbase -Dtask.id=jiazi_0609 -Dtask.base.dir=/user/jiazi/hbase/output2













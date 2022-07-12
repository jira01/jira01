
-- 远端actorRef设置参数：
akka.actor.provider = "akka.remote.RemoteActorRefProvider"
akka.remote.netty.tcp.hostname = $host
akka.remote.netty.tcp.port = $port

-- 启动spark-shell
spark-shell --master spark://nn1.hadoop:7077,nn2.hadoop:7077 --executor-memory 2G --total-executor-cores 3
spark-shell --master spark://nn1.hadoop:7077 --executor-memory 2G --total-executor-cores 3

-- 在 spark-shell中的运行命令：
-- // 计算hdfs目录下的wordcount，并输出到/user/panniu/spark/output
sc.textFile("hdfs://ns1/user/jiazi/spark/input").flatMap(_.split("\t")).map((_,1)).reduceByKey(_ + _).saveAsTextFile("hdfs://ns1/user/jiazi/spark/output")

spark-submit \
--class org.apache.spark.examples.SparkPi \
--master spark://nn1.hadoop:7077 \
--executor-memory 1G \
--total-executor-cores 2 \
/usr/local/spark/examples/jars/spark-examples_2.11-2.1.1.jar \
100

-- 在运行下面的任务的同时，kill 掉 ALIVE 的 master，看会不会切换
spark-submit \
--class org.apache.spark.examples.SparkPi \
--master spark://nn1.hadoop:7077,nn2.hadoop:7077 \
--executor-memory 1G \
--total-executor-cores 2 \
/usr/local/spark/examples/jars/spark-examples_2.11-2.1.1.jar \
5000

spark-submit \
--class org.apache.spark.examples.SparkPi \
--master yarn \
--queue jira \
/usr/local/spark/examples/jars/spark-examples_2.11-2.1.1.jar \
20000

spark-submit \
--class org.apache.spark.examples.SparkPi \
--master yarn \
--queue jira \
--deploy-mode cluster \
/usr/local/spark/examples/jars/spark-examples_2.11-2.1.1.jar \
5000

-- 看tasks
println(resRdd.toDebugString)

(key.hashCode() & Integer.MAX_VALUE) % numReduceTasks;
-- 设置全局序列化
conf.set("spark.serializer", classOf[KryoSerializer].getName)

-- 修改executor的storage memory内存比例配置：
spark-shell --master spark://nn1.hadoop:7077 --executor-cores 3 --executor-memory 5G --conf spark.storage.memoryFraction=0.1 --conf spark.memory.useLegacyMode=true

自动序列化
conf.set("spark.serializer", classOf[KryoSerializer].getName)

手动序列化  及注册
val classes: Array[Class[_]] = Array[Class[_]](classOf[ORCUtil],classOf[StructObjectInspector],classOf[OrcStruct])
conf.set("spark.serializer", classOf[KryoSerializer].getName)
conf.set("spark.kryo.registrationRequired","true")
conf.registerKryoClasses(classes)

集群上跑
spark-submit --driver-class-path /usr/local/spark/jars/*:/usr/local/hbase/lib/* --master yarn --queue jira --executor-memory 10G --executor-cores 5 --num-executors 3 ./jiraspark31-1.0-spark.jar orc2HFile /user/jiazi/hbase/user_install_status /hive/warehouse/jiazi.db/user_install_orc/000001_1

参考
-- spark-submit --jars $(echo /usr/local/hbase/lib/*.jar | tr ' ' ',') --master yarn --queue jira --executor-memory 5G --executor-cores 5 --num-executors 3 ./jiraspark31-1.0-spark.jar orc2HFile /user/jiazi/spark/output /hive/warehouse/jiazi.db/user_install_orc/000000_0


spark-submit --driver-class-path /usr/local/spark/jars/*:/usr/local/hbase/lib/* --executor-memory 5G --master yarn --queue jira ~/spark6-1.0-spark.jar sparkhbaseload /data/jira/user_install_status/20141228/part-r-00001 /user/qingniu/task/user_install_status

//读sql
val data: DataFrame = session.read.format("jdbc")
      .option("driver", classOf[Driver].getName)
      .option("url", "jdbc:mysql://nn2.hadoop:3306/jiracralwer")
      .option("dbtable", "jira_web_seed")
      .option("user", "jira")
      .option("password", "12345678").load()
	  
重点的参数：
设置读取创建时间为多长时间范围内的文件
sparkConf.set("spark.streaming.fileStream.minRememberDuration","2592000s")

spark-sql shell
这种方式每个人一个driver彼此之间的数据无法共享
spark-sql --master yarn --queue jira --num-executors 12 --executor-memory 5G

SET spark.sql.shuffle.partitions=20;
con.set("spark.sql.shuffle.partitions=20",1)
可以减少shuffle的次数
 spark-sql --help可以查看CLI命令参数：
 
 这种方式所有人可以通过driver连接彼此之间的数据可以共享
/usr/local/spark/sbin/start-thriftserver.sh --master yarn --queue jira
可以调大thriftserver的executor缓存和executor数量 --num-executors 12 --executor-memory 5G
/usr/local/spark/sbin/start-thriftserver.sh --master yarn --queue jira --num-executors 12 --executor-memory 5G

使用任意业务用户来使用beeline连接thriftserver
/usr/local/sprak/bin/beeline
!connect jdbc:hive2://op.hadoop:20000

DataFrame与Dataset支持一些特别方便的保存方式，比如保存成csv，可以带上表头，这样每一列的字段名一目了然

//保存
val saveoptions = Map("header" -> "true", "delimiter" -> "\t", "path" -> "hdfs://ns1/test")
datawDF.write.format("com.databricks.spark.csv").mode(SaveMode.Overwrite).options(saveoptions).save()
 cache.write.mode(SaveMode.Overwrite).format("orc").save("/Users/leohe/Data/output/sqlhiveorc2orc")
cache.write.mode(SaveMode.Overwrite).format("json").save("/Users/leohe/Data/output/sqlhiveorc2json")
//读取
val options = Map("header" -> "true", "delimiter" -> "\t", "path" -> "hdfs://ns1/test")
val datarDF= spark.read.options(options).format("com.databricks.spark.csv").load()

算子中的方法是在集群段跑，转换关系是在driver中跑
window
重点的参数：
设置读取创建时间为多长时间范围内的文件
sparkConf.set("spark.streaming.fileStream.minRememberDuration","2592000s")



kafka
创建topic
/usr/local/kafka/bin/kafka-topics.sh --create --replication-factor 2 --partitions 2 --topic jira_test --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181
-- 这里指定了2个副本，2个分区，topic名为jira_test，并且指定zookeeper地址

查看zk中的信息
/usr/local/zookeeper/bin/zkCli.sh -server nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181

查看已有的topic
/usr/local/kafka/bin/kafka-topics.sh --list --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181

查看topic的详情
/usr/local/kafka/bin/kafka-topics.sh --describe --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 --topic jira_test

启动一个生产者
/usr/local/kafka/bin/kafka-console-producer.sh --broker-list s1.hadoop:9092,s3.hadoop:9092,s4.hadoop:9092,s5.hadoop:9092,s6.hadoop:9092,s7.hadoop:9092,s8.hadoop:9092 --topic jira

启动一个消费者
/usr/local/kafka/bin/kafka-console-consumer.sh --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 --topic jira_test

查看consumer group列表，使用--list参数
/usr/local/kafka/bin/kafka-consumer-groups.sh --zookeeper nn1.hadoop:2181 --list


查看特定consumer group 详情，使用--group与--describe参数
/usr/local/kafka/bin/kafka-consumer-groups.sh --zookeeper nn1.hadoop:2181 --group group1 --describe
消费的topic名称、partition id、consumer group最后一次提交的offset、最后提交的生产消息offset、消费offset与生产offset之间的差值、当前消费topic-partition的group成员id

修改Partitions只能增加(扩容）
/usr/local/kafka/bin/kafka-topics.sh --alter --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 --topic jira_test --partitions 3

修改备份数量
/usr/local/kafka/bin/kafka-reassign-partitions.sh --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181  --reassignment-json-file /home/qingniu/topic.json --execute

验证修改后的结果是否与json文件中描述的格式一致
/usr/local/kafka/bin/kafka-reassign-partitions.sh --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181  --reassignment-json-file /home/qingniu/topic.json --verify

用于修改备份数量创建的topic.json文件格式
使用下面这个json
{"partitions":[{"topic":"jira_test","partition":0,"replicas":[0,1,2]},{"topic":"jira_test","partition":1,"replicas":[0,1,2]},{"topic":"jira_test","partition":2,"replicas":[0,1,2]}],"version":1}

删除topic
/usr/local/kafka/bin/kafka-topics.sh --delete --zookeeper nn1.hadoop:2181,nn2.hadoop:2181,s1.hadoop:2181 --topic jira_test

















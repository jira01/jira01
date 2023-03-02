# hive默认分隔符

在hive建表中，默认的分隔符为 ‘，’ ，可以指定想用的分隔符

hive默认的列分割类型为org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe，这其实就是^A分隔符，hive中默认使用^A(ctrl+A)作为列分割符，如果用户需要指定的话，等同于row format delimited fields terminated by '\001'，因为^A八进制编码体现为'\001'.所以如果使用默认的分隔符，可以什么都不加，也可以按照上面的指定加‘\001’为列分隔符，效果一样。 hive默认使用的行分隔符是'\n'分隔符 ，也可以加一句：LINES TERMINATED BY '\n' ，加不加效果一样。但是区别是hive可以通过row format delimited fields terminated by '\t'这个语句来指定不同的分隔符，但是hive不能够通过LINES TERMINATED BY '$$'来指定行分隔符，目前为止，hive的默认行分隔符仅支持‘\n’字符。否则报错


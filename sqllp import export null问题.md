# import	

最近用sqoop将mysql的一张表导入到hive中，发现以前is null的字段导入到hive的时候，被转换为了字符串’NULL’或’null’。
当导入的时候加上–direct选项的时候，null值导入变成了字符串’NULL’,命令如下：

```sql
sqoop import  \
    --connect "jdbc:mysql://${hostname}:3306/${db_name}?useUnicode=true&characterEncoding=UTF-8" \
    --username ${user_name} \
    --password ${pwd} \
    --table ${table_name} \
    --null-string '\\N' \
    --null-non-string '\\N' \
    --fields-terminated-by '\t' \
    --lines-terminated-by '\n' \
    --hive-import  \
    --hive-overwrite \
    --direct  \
    -z \
    --compression-codec lzo \
    -m 1 \
    --hive-table ${table_name}

```



当导入的时候去掉–direct选项的时候，null值导入变成了字符串’null’。

然后去网上搜了资料说需要加–null-string ‘\N’ –null-non-string ‘\N’选项，继续尝试，发现还是不行，没有任何用处。

然后我去翻看了一下hive官方文档关于null值的描述，发现还需要在表级设置’serialization.null.format’参数。

alter table ${table_name} SET SERDEPROPERTIES('serialization.null.format' = '\\N'); 

然后导入的时候，一定要注意去掉–direct选项:

```sql
sqoop import  \
    --connect "jdbc:mysql://${hostname}:3306/${db_name}?useUnicode=true&characterEncoding=UTF-8" \
    --username ${user_name} \
    --password ${pwd} \
    --table ${table_name} \
    --null-string '\\N'  \
    --null-non-string '\\N' \
    --fields-terminated-by '\t' \
    --lines-terminated-by '\n' \
    --hive-import  \
    --hive-overwrite \
    -z \
    --compression-codec lzo \
    -m 1 \
    --hive-table ${table_name}
```



# export

```sql
--input-null-string '\\N' 
--input-null-non-string '\\N' 
--fields-terminated-by '\t'
```


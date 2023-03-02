# hive中的named_struct和collect_set

## ①named_struct

语法结构
named_struct(name1,val1,name2,val2,...)
 用给定的names和values创建一个结构体

 在学习的数据仓库的项目中我们需要将一些字段的信息放在一起，

```sql
select 
sku_id,   	   named_struct('attr_id',attr_id,'value_id',value_id,'attr_name',attr_name,'value_name',value_name)
from ods_sku_attr_value_full
where dt='2020-06-14';
```




结果 

## ②collect_set

语法结构

```sql
collect_set(col)
```

作用：返回没有重复元素的集合；算是聚合函数的一种。
返回结果类型：Array
在上面的查询结果中，我们还可以对有相同sku_id的元素进行聚合，放到同一个Array中。

```sql
select
  sku_id,
 collect_set(named_struct('sale_attr_id',sale_attr_id,'sale_attr_value_id',sale_attr_value_id,'sale_attr_name',sale_attr_name,'sale_attr_value_name',sale_attr_value_name))
from ods_sku_sale_attr_value
where dt='2020-06-14'
group by sku_id;
```

结果：(以一行为例)

```sql
[
{"attr_id":"106","value_id":"176","attr_name":"手机一级","value_name":"安卓手机"},		 {"attr_id":"107","value_id":"177","attr_name":"二级手机","value_name":"小米"},{"attr_id":"23","value_id":"83","attr_name":"运行内存","value_name":"8G"},{"attr_id":"24","value_id":"82","attr_name":"机身内存","value_name":"128G"}
]
```




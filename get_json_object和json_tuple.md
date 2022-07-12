在技术对app进行埋点时，会讲多个字段存放在一个数组中，因此模型调用数据时，要对埋点数据进行解析，以作进一步的清洗。本文将介绍解析json字符串的两个函数：get_json_object和json_tuple。

 

表结构如下：

<img src="F:\Typora图片\jason.png" style="zoom:150%;" />

 

 

一、get_json_object

 

函数的作用：用来解析json字符串的一个字段：

 ```sql
select get_json_object(flist,'$.filtertype') as filtertype

   ,get_json_object(flist,'$.filtersubtype')as filtersubtype

   ,get_json_object(flist,'$.filtername') as filtername

from aaaaaaa
 ```

运行结果如下(只解析了一条数据)：

![](F:\Typora图片\20180608165009647.png)

 

二、json_tuple

 

函数的作用：用来解析json字符串中的多个字段

 ```sql
select a.flist

   ,b.filtertype

   ,b.filtersubtype

   ,b.filtername

 from aaaaaaaaa a 

lateral view json_tuple(flist,'filtertype', 'filtersubtype', 'filtername') b as 

filtertype, filtersubtype,filtername; 
 ```





运行结果如下：

 

get_json_object与json_tuple在解析埋点数据时会经常用到，而且比较有效且很简单~


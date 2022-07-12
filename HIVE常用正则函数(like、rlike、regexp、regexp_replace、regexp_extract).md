

####  **HIVE常用正则函数(like、rlike、regexp、regexp_replace、regexp_extract)** 

Oralce中regex_like和hive的regexp对应

### LIKE

语法1: A LIKE B
语法2: LIKE(A, B)
操作类型: strings
返回类型: boolean或null
描述: 如果字符串A或者字符串B为NULL，则返回NULL；如果字符串A符合表达式B的正则语法，则为TRUE；否则为FALSE。B中字符"_"表示任意单个字符，而字符"%"表示任意数量的字符。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
hive> select 'football' like '%ba';
OK
false
 
 
hive> select 'football' like '%ba%';
OK
true
 
 
hive> select 'football' like '__otba%';
OK
true
 
 
hive> select like('football', '__otba%');
OK
true
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### RLIKE

语法1: A RLIKE B
语法2: RLIKE(A, B)
操作类型: strings
返回类型: boolean或null
描述: 如果字符串A或者字符串B为NULL，则返回NULL；如果字符串A符合JAVA正则表达式B的正则语法，则为TRUE；否则为FALSE。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
hive> select 'football' rlike 'ba';
OK
true
 
 
hive> select 'football' rlike '^footba';
OK
true
 
 
hive> select rlike('football', 'ba');
OK
true
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### Java正则:

"." 任意单个字符
"*" 匹配前面的字符0次或多次
"+" 匹配前面的字符1次或多次
"?" 匹配前面的字符0次或1次
"\d" 等于 [0-9]，使用的时候写成'\d'
"\D" 等于 [^0-9]，使用的时候写成'\D'

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
hive> select 'does' rlike 'do(es)?';
OK
true

hive> select '\\';
OK
\

hive> select '2314' rlike '\\d+';
OK
true
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### REGEXP

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
语法1: A REGEXP B
语法2: REGEXP(A, B)
操作类型: strings
返回类型: boolean或null
描述: 功能与RLIKE相同

hive> select 'football' regexp 'ba';
OK
true


hive> select 'football' regexp '^footba';
OK
true


hive> select regexp('football', 'ba');
OK
true


语法: regexp_replace(string A, string B, string C)
操作类型: strings
返回值: string
说明: 将字符串A中的符合java正则表达式B的部分替换为C。

hive> select regexp_replace('h234ney', '\\d+', 'o');
OK
honey
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### REGEXP_REPLACE

语法: regexp_replace(string A, string B, string C)
操作类型: strings
返回值: string
说明: 将字符串A中的符合java正则表达式B的部分替换为C。

```
hive> select regexp_replace('h234ney', '\\d+', 'o');
OK
honey
```

### REGEXP_EXTRACT

语法: regexp_extract(string A, string pattern, int index)
返回值: string
说明：将字符串A按照pattern正则表达式的规则拆分，返回index指定的字符，index从1开始计。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
hive> select regexp_extract('honeymoon', 'hon(.*?)(moon)', 0);
OK
honeymoon
 
 
hive> select regexp_extract('honeymoon', 'hon(.*?)(moon)', 1);
OK
ey
 
 
hive> select regexp_extract('honeymoon', 'hon(.*?)(moon)', 2);
OK
moon
```
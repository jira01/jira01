# hive常用函数一般分为下面几个部分：

算数运算符：+，- ，*， /
关系运算符：== , <>(不等于) , > , >= , < , <=
逻辑运算符：and	or	not

数学函数
字符串函数
集合函数
日期函数
条件函数
侧视图
聚合函数
窗口函数
over重句

数学函数
1、取余函数，只能支持正数，参数含义：n%m
	mod(n,m)	
	

	select mod(3,5);
	+------+
	| _c0  |
	+------+
	| 3    |
	+------+

2、取余函数，正负都支持，如果n为负，m为正，结果为正；n为正，结构为负，结果为负
	pmod(n,m)
	
	select pmod(-3,5);
	+------+
	| _c0  |
	+------+
	| 2    |
	+------+
3、随机函数，算是一个伪随机，如果里面的seed是同一个数，那么得到的随机数也是相同的，，基于这个效果，可以用来做秘钥
	rand(seed)
	
	select rand(12345678);
	+---------------------+
	|         _c0         |
	+---------------------+
	| 0.7005605651027493  |
	+---------------------+
4、取表达式符号，结果为正返回1，为负返回-1
	sign(num)
	
	select sign(5-6);
	+-------+
	|  _c0  |
	+-------+
	| -1.0  |
	+-------+
5、返回数值本身
	positive(num)
6、返回数值相反数
	negative(num)
7、将十进制参数转换成二进制数值
	bin(num10)
	
	select bin(16);
	+--------+
	|  _c0   |
	+--------+
	| 10000  |
	+--------+
8、进制转换，不同进制相互转换，第一个参数是数值，第二个参数代表第一个参数的进制，第三个参数代表要转成的进制
	conv(num,from_base,to_base)
	
	select conv(16,10,2);
	+--------+
	|  _c0   |
	+--------+
	| 10000  |
	+--------+
9、返回参数列表中的最大值
	greatest(T...ts)
	
	select greatest(12,23,43);
	+------+
	| _c0  |
	+------+
	| 43   |
	+------+
10、返回参数列表中最小值
	least(T..ts)
	
	select least(12,23,43);
	+------+
	| _c0  |
	+------+
	| 12   |
	+------+
11、银行家舍入，当左边的数值是奇数的时候，向上舍入；当左边的值是偶数的时候，向下舍入
	bround(decimal)
	
	select bround(2.5);
	+------+
	| _c0  |
	+------+
	| 2    |
	+------+
12、左移一位，就是乘2,左移两位是乘2的平方
	shiftleft(bigint|int num,int num)
	
	select shiftleft(5,1);
	+------+
	| _c0  |
	+------+
	| 10   |
	+------+
13、右移一位是除以2
	shiftright(bigint|int num,int num)
	
	select shiftright(10,1);
	+------+
	| _c0  |
	+------+
	| 5    |
	+------+

字符串函数
1、拼接函数：支持混合类型的参数拼接
	concat(int|string|...)
	

	select concat(21,'asd',23.15);
	+-------------+
	|     _c0     |
	+-------------+
	| 21asd23.15  |
	+-------------+
2、拼接函数：只能同类型拼接,第一个参数是拼接符，没有默认，必须写
	concat_ws(string sep,string...|array<string>)
	
	select concat_ws('**','xc','aad');
	+----------+
	|   _c0    |
	+----------+
	| xc**aad  |
	+----------+
3、截取字符串：第一个参数cnt是要截取的字符串，参数pos是从1开始到截止的位置，如果不写参数3就会从pos位置开始截取到最后，包括pos位置上的字符，参数len是要截取的长度，可以省略不写
	sbustr(string cnt,int pos[,int len])
	
	select substr('wangtengfei',3);
			+------------+
			|    _c0     |
			+------------+
			| ngtengfei  |
			+------------+
	select substr('wangtengfei',3,3);
			+------+
			| _c0  |
			+------+
			| ngt  |
			+------+
4、寻找字符串首字母出现的位置：参数substr是想要查找的子字符串；参数str是被查找的父字符串；pos是指定从str第几个开始查找，可以省略不写，不写就是默认从第一个开始查找。如果从pos位置开始寻找，找到substr首字母，就返回第一次出现substr首字符出现的位置，如果没找到就返回0；
	locate(sbustr,str[,pos])

	select locate('bc','abcdw');
	+------+
	| _c0  |
	+------+
	| 2    |
	+------+
	select locate('bc','abcdw',3);
	+------+
	| _c0  |
	+------+
	| 0    |
	+------+
5、查找字符串位置：参数str是要被寻找的父字符串，参数substr是要寻找的子字符串；寻找str中substr首字母出现的位置，没有就返回0
	instr(str,substr)
	

	select instr('abcdw','bc');
	+------+
	| _c0  |
	+------+
	| 2    |
	+------+
6、替换字符串:参数str是父字符串，参数substr是要被替换的字符串，rep是要替换成的字符串；将str中的substr替换成rep
	replace(str,substr,rep)
	

	select replace('123abc456','abc','###');
	+------------+
	|    _c0     |
	+------------+
	| 123###456  |
	+------------+
7、替换字符串：参数str是父字符串，参数regex是正则规则，参数rep是要替换成的字符串；将str中的满足regex规则的字符串替换成rep
	regexp_replace(str,regex,rep)
	
	select regexp_replace('123dad45sda','[a-z]+','@@');
	+------------+
	|    _c0     |
	+------------+
	| 123@@45@@  |
	+------------+
#### 8、分割字符串：将字符串str以标点符号作为第一个维度分割，再以空格作为第二个维度分割，将str分割成一个二维数组

​	sentences(str)
​	

	select sentences('I Love you,w: s ,a');
	+-----------------------------------+
	|                _c0                |
	+-----------------------------------+
	| [["I","Love","you","w","s","a"]]  |
	+-----------------------------------+
9、词频统计字符串：参数arr是字符串数组，注意参数的类型，数组里面还有数组，还是字符串类型的；n是连续几个单词做统计，topk是返回最高的几个；对数组单词做一个或连续几个做词频统计，返回最高的topk个
	ngrams(array<array<string>> arr,int n, int topk)
	

	select ngrams(array(array('how','are','you'),array('how','old','are','you')),1,2);
	+----------------------------------------------------+
	|                        _c0                         |
	+----------------------------------------------------+
	| [{"ngram":["how"],"estfrequency":2.0},{"ngram":["you"],"estfrequency":2.0}] |
	+----------------------------------------------------+
11、词频统计字符串：针对arr中连续size(cnt)个单词的组合以cnt中非null内容匹配统计，按数量倒序排列，将topk个结果返回
	context(array<array<string>> arr,array<string> cnt,int topk)

12、编码转换:将cnt转换成encode编码的内容
	encode(string cnt,string encode)

13、类型转换：将exp转换成type类型的
	cast(exp as type)
	
	select cast(123 as float);
	+--------+
	|  _c0   |
	+--------+
	| 123.0  |
	+--------+


14、提取字符串：提取json格式字符串指定key的值，参数json是json格式的字符串，path是指定的key，提取想对应的value；；；一次只能解析一项，但是可以多层解析
	get_json_object(string json,string path)
	
	select get_json_object('{"name":"henry","hobbies":["s","a","c"],"address":{"province":"js","city":"nj"}}','$.hobbies');
	+----------------+
	|      _c0       |
	+----------------+
	| ["s","a","c"]  |
	+----------------+
	select get_json_object('{"name":"henry","hobbies":["s","a","c"],"address":{"province":"js","city":"nj"}}','$.hobbies[0]');
	+------+
	| _c0  |
	+------+
	| s    |
	+------+
15、提取字符串：提取json格式字符串中指定key的value值；一次可以解析多个，但是只能解析一层
	json_tuple(string json,string p1,string p2,...)
	select json_tuple('{"name":"henry","hobbies":["s","a","c"],"address":{"province":"js","city":"nj"}}','name','hobbies','address');
	+--------+----------------+--------------------------------+
	|   c0   |       c1       |               c2               |
	+--------+----------------+--------------------------------+
	| henry  | ["s","a","c"]  | {"province":"js","city":"nj"}  |
	+--------+----------------+--------------------------------+
16、匹配字符串：返回的true和false，cnt是否存在于文件filepath中，，filepath是文件路径
	in_file(string cnt,string filepath)
	select in_file('KY08','/root/test/clacpy.log');
	+-------+
	|  _c0  |
	+-------+
	| true  |
	+-------+
17提取内容：解析rul,根据part提取内容，当part为QUERY时候添加key进行单独键的提取；part可以是：PROTOCOL,HSOT,QUERY,REF,PATH,USERINGFO
	parse_url(string url,string part[,string key]);
	
18、正则匹配:str是否能满足正则表达式regex
	str rlike regex
	
	 select '{"name":"henry","age":"23","gender":"male"}' rlike '^.*?"age":"\\d+".*?$';
	+-------+
	|  _c0  |
	+-------+
	| true  |
	+-------+
19、提取字符串：根据group_regex匹配str提取第pos个元素
	regexp_extract(str,group_regex,pos)
	
	 select regexp_extract('{"name":"henry","age":"23","gender":"male"}','\\{"name":"(.*?)","age":"(.*?)","gender":"(.*?)"\\}',2);
	+------+
	| _c0  |
	+------+
	| 23   |
	+------+
20、分割字符串:根据正则表达式regex分割字符串str，支持多字符串分割
	select(str,regex)
	select split('aa,bb.cc',',|\\.');
	+-------------------+
	|        _c0        |
	+-------------------+
	| ["aa","bb","cc"]  |
	+-------------------+
21、字符串转化成map：将字符串cnt使用能够kvsSep作为键值对之间分隔符kvSep作为键和值的分隔符转化map对象
	str_to_map(strig cnt,string kvsSep,string kvSep)
	
	select str_to_map('name:henry,age:18,gender:male',',',':');
	+----------------------------------------------+
	|                     _c0                      |
	+----------------------------------------------+
	| {"name":"henry","age":"18","gender":"male"}  |
	+----------------------------------------------+
22、替换字符串：按照from同位置将str中的内容替换为to的内容
	translate(str,from,to)
	select translate('abcdes','bc','23');
	+---------+
	|   _c0   |
	+---------+
	| a23des  |
	+---------+
23、字符串加密：非对称加密，不可逆;concat将字符串拼接到一起，可以通过改变前后两个字符串的值，对中间的进行加密
	md5(concat('salt_pewfix','field','saltusffix'))
	select md5(concat('salt_prefix','field','saltsuffix'));
	+-----------------------------------+
	|                _c0                |
	+-----------------------------------+
	| 905568bd1a66800166dc8941c276db12  |
	+-----------------------------------+
24、字符串加密：将str字符串使用base64加密，简单的对称加密
	base64(binary(str))
	
	select base64(binary('absn'));
	+-----------+
	|    _c0    |
	+-----------+
	| YWJzbg==  |
	+-----------+
25、字符串解密：将str字符串使用unbase64解密
	unbase64(str)
	
	select unbase64('YWJzbg==');
	+-------+
	|  _c0  |
	+-------+
	| absn  |
	+-------+
26、字符串加密：复杂加密  ，参数2是一个秘钥，解密时候用；'secretKey的长度：16+n*8(n是整除，包括0)
	base64(aes_encrypt(string cnt,string secreKey))
	
	select base64(aes_encrypt('I Love You','kb12202106160890'));
		+---------------------------+
		|            _c0            |
		+---------------------------+
		| P48HxSlhsjK8/QUrDFvTSg==  |
		+---------------------------+
	27、字符串解密:密码加上秘钥才能解密
		aes_decrypt(unbase64(strAfterEnc),string secondary)
		
		 select aes_decrypt(unbase64('P48HxSlhsjK8/QUrDFvTSg== '),'kb12202106160890');
			+-------------+
			|     _c0     |
			+-------------+
			| I Love You  |
			+-------------+

日期函数

 计算某一个日期是星期几： 

```sql
SELECT if(pmod(datediff('2020-04-20', '1920-01-01') - 3, 7)='0', 7, pmod(datediff('2020-04-20', '1920-01-01') - 3, 7)) 

```



1、返回系统当前日期
	current_date();
	

	select current_date();
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-06-20  |
	+-------------+
2、返回系统当前日期的完整格式（精确到毫秒）
	current_timestamp().
	
	select current_timestamp();
	+--------------------------+
	|           _c0            |
	+--------------------------+
	| 2021-06-20 17:46:42.237  |
	+--------------------------+
3、返回系统当前时间戳(单位是秒)
	unix_timestamp()
	
	select unix_timestamp();
	+-------------+
	|     _c0     |
	+-------------+
	| 1624182432  |
	+-------------+
4、返回时间戳，如果只有参数1，返回参数1对应的完整格式的时间戳，如果有两个参数，返回参数1对应参数2格式的时间戳
	unix_timestamp(string|date|datetime|timestamp,date_format)
	
	select unix_timestamp('2020-5-1 10:11:12.190');
	+-------------+
	|     _c0     |
	+-------------+
	| 1588327872  |
	+-------------+
	select unix_timestamp('2020-5-1 10:11:12.190','yyyy-MM');
	+-------------+
	|     _c0     |
	+-------------+
	| 1588291200  |
	+-------------+
5、返回start_date之后第days天的日期，，date可以是字符串，int支持负数
	date_add( date start_date,int days)	
	select date_add(current_date(),3);
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-06-23  |
	+-------------+
6、返回start_date之后第months月的日期，支持负数
	add_months(string|date|datetime|timestamp start_date,int months)
	select add_months(current_date,-1);
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-05-20  |
	+-------------+
7、返回两个日期之间的天数差值		可以用上面的date_add，因为支持负数
	datediff(big_date,small_date)
8、返回时间戳对应的date_format格式字符串信息	date_format可以不写
	from_unixtime(bigint,date_format)
	
	select from_unixtime(12345678923,'yyyy-MM');
	+----------+
	|   _c0    |
	+----------+
	| 2361-03  |
	+----------+
9、返回日期对应的date_format格式字符串信息	
	date_format(string|date|datetime|timestamp, date_format)
	select date_format('2361-03-21 19:15:23','yyyy/MM');
	+----------+
	|   _c0    |
	+----------+
	| 2361/03  |
	+----------+
10、返回日期的年月日
	to_date(string|datetime|timestamp)
	select to_date('2361-03-21 19:15:23');
		+-------------+
		|     _c0     |
		+-------------+
		| 2361-03-21  |
		+-------------+
11、返回距离指定日期最近的下一个weekDay；weekDay可以是：mo,tu,we,th,fr,sa,su
		next_day(string|datetime|timestamp,weekDay)
		select next_day(current_date(),'mo');
		+-------------+
		|     _c0     |
		+-------------+
		| 2021-06-21  |
		+-------------+
12、返回参数日期所属月份的最后一天的日期
		last_day(string|datetime|timestamp)
		select last_day(current_date());
		+-------------+
		|     _c0     |
		+-------------+
		| 2021-06-30  |
		+-------------+
13、年最后一天
		select concat(year(current_date()),'-12-31');
		+-------------+
		|     _c0     |
		+-------------+
		| 2021-12-31  |
		+-------------+
14、季度最后一天
	select date_sub(add_months(trunc(current_date(),'Q'),3),1);
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-06-30  |
	+-------------+
	select date_add(add_months(trunc(current_date(),'Q'),3),-1);
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-06-30  |
	+-------------+
15、周最后一天
	select date_sub(next_day(current_date(),'MO'),1);
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-06-20  |
	+-------------+
16、返回参数1对应参数2单位的第一天；part : YY=>年  Q=>季度		MM=>月
	trunc(string|date|datetime|timestamp,part)
	select trunc(current_date(),'YY');
	+-------------+
	|     _c0     |
	+-------------+
	| 2021-01-01  |
	+-------------+

17、返回参数日期所属周的第一天(星期一)日期
	date_add(next_day(date,'MO'),-7)
18、返回两个日期之间的月数差	，结果带小数
	months_between(big_date,small_date)
	select months_between(current_date(),'2021-3-15');
		+-------------+
		|     _c0     |
		+-------------+
		| 3.16129032  |
		+-------------+
————————————————
版权声明：本文为CSDN博主「清欢渡12138」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_49180684/article/details/117996334
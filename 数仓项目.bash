#数据库备份命令【不用执行】
mysqldump -hlocalhost -uhainiushop -P3306 -p12345678 hainiu_shop > /tmp/hainiu_shop.sql
#执行这个导入命令就行
mysql -uhainiushop -P3306 -p12345678 hainiu_shop < /tmp/hainiu_shop.sql
Proxool是一种Java数据库连接池技术
# 下面是成的日志
# ip
192.168.88.7
# 用户名（没用）
-
# 时间
09/Sep/2020:12:45:09 +0800
# 请求
GET /lookDetail.action?id=22 HTTP/1.1
# 状态
200
# 字节数
13153
# post请求的body数据
-
# refer
http://www.hainiushop.com/index.jsp
# 用户浏览器代理
Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36
# 代理ip
-
# 浏览器cookie记录的userid
c3d7d6b6b0644d3f992439e0c859332d
# 网站用户登录名称（没登录前是- ，登录后是用户注册名称）
pan123



# 2）service日志
# 时间 和 ip（哪个ip地址请求的）
2020-09-09 13:03:27 192.168.88.7
# user_id(nginx从cookie里拿出来的，传到service)
c3d7d6b6b0644d3f992439e0c859332d
# 用户名称
pan123 
# 请求
/goods/goods_detail.jsp?id=22
#请求码 （可有可无）
#  service返回给shop的请求结果（以json格式）
{"brandId":9,"remainHour":0,"pageSize":5,"curPage":1}
{"type":"success","items":[{"goodsSn":"49865120004","goodsId":47,
"goodsCname":"千禧冰河休闲鞋女鞋2020年夏季新款网面潮流透气女生运动鞋子",
"goodsEname":"","goodsImg":"2020/06/18/2020_06_18_659777.png_501x394",
"goodsPrice":398.0,"remainHour":0},{"goodsSn":"49865120008","goodsId":56,
"goodsCname":"百丽星辰仙女风凉鞋女2020春夏新商场同款高跟水晶凉鞋BSCD4AH0",
"goodsEname":"","goodsImg":"2020/06/18/2020_06_18_466561.jpg_323x430",
"goodsPrice":559.0,"remainHour":0}],"totalCount":2,"pageCount":1,"pageSize":5,"curPage":1,"num":5}
# 前端调用哪个类的哪个方法请求service 
com.hainiu.shop.action.goods.GoodsAction
listBrandHotGoods
# service端用哪个类哪个方法处理请求
com.hainiu.service.shopGoods.action.goods.QueryAction
listBrandHotGoods
# service端返回的是哪个对象的数据，整个对象封装了返回的json数据
java.util.ArrayList<com.hainiu.global.model.shop.goods.GoodsSearchModel>


































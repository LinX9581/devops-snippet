redis-cli
https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/747735/


set key value
get key
* 取得所有Key
keys *

* 匹配apple的所有Key
keys apple* 

* 同時設定/取得多個key-value
mset name kai age 18
mget name age

* expire key time(单位为s)

查看某一个key的过期时间：TTL key


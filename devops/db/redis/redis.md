
# 官方文件
https://github.com/redis/node-redis

## install
sudo apt update
sudo apt install redis-server
sudo systemctl status redis-server
sudo systemctl restart redis-server

## resid 記憶體滿的機制
* noeviction
只能讀不能寫

* allkeys-lru , allkeys-random
刪除最少使用的Key , 隨機

* volatile-lru , volatile-random , volatile-ttl
刪除有有效期限 且 最少使用的Key , 隨機 , 優先刪快死的

set key value
get key
* 取得所有Key
keys *

* 匹配apple的所有Key
keys apple* 

* 同時設定/取得多個key-value
mset name kai age 18
mget name age

https://medium.com/10coding/node-js-%E4%BD%BF%E7%94%A8-redis-%E5%85%A7%E5%AD%98%E4%BE%86%E5%AD%98%E5%8F%96%E6%9C%AC%E5%9C%B0%E8%B3%87%E6%96%99-9557660196f4

https://medium.com/dean-lin/%E7%94%A8-node-js-redis-%E8%A7%A3%E6%B1%BA%E9%AB%98%E4%BD%B5%E7%99%BC%E7%A7%92%E6%AE%BA%E5%95%8F%E9%A1%8C-e814fe26a0f2
# 筆記大全
https://wangchujiang.com/reference/docs/regex.html

leetcode 

## 限流
* api 
用 token取代 IP做限流 確保每個API都有token

* 針對網站
針對瀏覽器發 ClientID，然後以 ClientID 來做 rate limite / throttle
如果回送有 ClientID 的 Cookie 或 Payload，就針對 ClientID 去累計，沒有就配發 ClientID
另外管制同一個 IP 下配發的 ClientID 總量
以及 ClientID 超過 14 天沒使用就移除
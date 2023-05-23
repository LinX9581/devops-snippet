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


## 網站速度測試
https://pagespeed.web.dev/

## get client userAgent
https://user-agent-client-hints.glitch.me/


# 微服務
https://ithelp.ithome.com.tw/articles/10233974
拆分原則
1. 水平擴容
2. 數據分區 Ex 依系統分流、依地區分流等等
3. 業務分解
Ex 結帳、驗證、購買、註冊
客戶、訂單、報表、商品
4. 前後分離
5. 無狀態
有狀態的存在redis database
6. restful
無狀態的http協議

## 資料庫
異步複製
主掛了 從當主
有些來不及複製過來的binlog 會導致從會有部分不完整
而且從是走單線程

## CAP
1. Consistency一致性
2. Availability可用性 
確保每個請求都能得到回應 不管成功或失敗
3. Partition-tolerance分區容錯

多數NOSQL 會採用 A+P
## 價錢總攬
http://blog.maxkit.com.tw/2017/06/google-computer-engine.html

# 官方
https://cloud.google.com/pricing/list#section-4

## GCS
前5G免費 1G/0.6U
(per GB per Month)
Standard Storage $0.020
Nearline Storage 0.010
Coldline Storage 0.005
Archive Storage  0.0015 (最低允許儲存天數 365天, 提前刪除一樣會扣整年的費用)

## StackDriver Logging
前50G免費 1G/0.5U
monitor 改成用多少付多少

## Cloud Filestore
HDD 1T~63.9T 1G/0.22
SSD 2.5T~63.9T 1G/0.33

## load balance
First 5 forwarding rules	$0.025	Per Hour
Per additional forwarding rule	$0.010	Per Hour
Ingress data processed by load balancer	$0.008	Per GB

* 只要有一組LB 外部IP就會被收這筆費用 一個月18U
Cloud Load Balancer Forwarding Rule Minimum Global

* 外部訪問LB的流量費
Global External Application Load Balancer Outbound Data Processing for Taiwan (asia-east1)


## Cloud function
1. price
https://cloud.google.com/functions/pricing

* 免費額度
類型	        價格/GB
外送資料	    $0.12 美元
每月外送資料	5 GB 的免費額度
傳入資料	    免費
將資料外送至相同區域的 Google API	免費

## Big Query
1. 已量計價 每月前1T免費 1T/$5

2. 固定費率 1M/$2300 100運算單元
不包含 儲存空間 BI Engin

3. 儲存費用 動態儲存 1G/$0.02 長期儲存 1G/$0.01

4. 網路費
0~1T Engress 0.12
1~10T Engress 0.11
10~ Engress 0.08
https://cloud.google.com/vpc/network-pricing?hl=zh-tw

https://cloud.google.com/bigquery/pricing/?hl=zh-tw&utm_source=google&utm_medium=cpc&utm_campaign=japac-TW-all-en-dr-skws-all-all-trial-e-dr-1009882&utm_content=text-ad-none-none-DEV_c-CRE_502188639016-ADGP_Hybrid%20%7C%20SKWS%20-%20EXA%20%7C%20Txt%20~%20Data%20Analytics%20~%20BigQuery_Pricing-KWID_43700061618151048-kwd-143282056846&userloc_9040379-network_g&utm_term=KW_bigquery%20pricing&gclid=CjwKCAjw8sCRBhA6EiwA6_IF4QNi7TixUa1rqg8OItyfVm-sKBlKsEMo-LARcjUS7cpN93wR7iQmyxoCIiAQAvD_BwE&gclsrc=aw.ds
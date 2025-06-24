
## 路由的觀念
VPC 剛建立預設就會建立一個 Route Table 會自動關連到底下所有的 subvpc 讓他們得以對外連網
如果有其他 subvpc 要走 nat
要另外建立 route table 並且關聯到該 subvpc 以及建立 route 指向 nat ip 為 0.0.0.0/0

## NAT 的觀念
NAT 建立的時候要選擇 subvpc 要選擇有對外連網的 subvpc
這樣 route table 指向 nat 才能連網

## 檢查特定 Route Table 關聯了哪些子網
aws ec2 describe-route-tables --route-table-ids <ROUTE_TABLE_ID>

# 檢查特定子網使用哪個 Route Table  
aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=<SUBNET_ID>"

# 檢查子網中有哪些實例
aws ec2 describe-instances --filters "Name=subnet-id,Values=<SUBNET_ID>"
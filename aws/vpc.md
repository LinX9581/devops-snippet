
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

## SG
要注意 刪除SG 必須要 EC2 沒有使用該 SG

## Flow logs 
每個 VPC 都要開啟 Flow logs 並且拋到 cloudwatch

下面指令的流程是
1. Cloudwatch 要建立 Group 儲存 VPC 的 log
2. 給 Flow Logs 寫入 Cloudwatch 的權限
3. 啟用 Flow Logs 讓他拋到一開始建立的 Group 並且給定權限

* CloudWatch Log Group
aws logs create-log-group --log-group-name VPCFlowLogs-vpc-c046d2a5 --region ap-northeast-1

* 建立 Flow Logs 的 role
```
aws iam create-role --role-name flowlogsRole --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}' --region ap-northeast-1
```

* 設定該 Role 有甚麼權限
```
sudo aws iam put-role-policy --role-name flowlogsRole --policy-name flowlogsDeliveryRolePolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}' --region ap-northeast-1
```

* 啟用 flow logs
```
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-c046d2a5 \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name VPCFlowLogs-vpc-c046d2a5 \
  --deliver-logs-permission-arn arn:aws:iam::405442407111:role/flowlogsRole \
  --region ap-northeast-1
```

## 查看 flow logs 

* 撈出近一小時的 Log
aws logs filter-log-events \
  --log-group-name VPCFlowLogs-vpc-3914485c \
  --region ap-northeast-1 \
  --start-time $(date -d '1 hour ago' +%s)000

* 查看目標來自 172.30.0.105
aws logs filter-log-events \
  --log-group-name VPCFlowLogs-vpc-3914485c \
  --region ap-northeast-1 \
  --filter-pattern '[version, account, eni, source, destination="172.30.0.105", srcport, destport, protocol, packets, bytes, windowstart, windowend, action="ACCEPT", flowlogstatus]' \
  --start-time $(date -d '1 hour ago' +%s)000 \
  --end-time $(date +%s)000 \
  --output json | jq -r '.events[] | 
    (.timestamp | . / 1000 + 28800 | strftime("%Y-%m-%d %H:%M:%S")) + " - " + 
    (.message | split(" ") | .[3:] | join(" "))'

* 查看來源來自 172.30.0.105
aws logs filter-log-events \
  --log-group-name VPCFlowLogs-vpc-3914485c \
  --region ap-northeast-1 \
  --filter-pattern '[version, account, eni, source="172.30.0.105", destination, srcport, destport, protocol, packets, bytes, windowstart, windowend, action="ACCEPT", flowlogstatus]' \
  --start-time $(date -d '1 hour ago' +%s)000 \
  --end-time $(date +%s)000 \
  --output json | jq -r '.events[] | 
    (.timestamp | . / 1000 + 28800 | strftime("%Y-%m-%d %H:%M:%S")) + " - " + 
    (.message | split(" ") | .[3:] | join(" "))'


aws logs filter-log-events \
  --log-group-name VPCFlowLogs-vpc-3914485c \
  --region ap-northeast-1 \
  --filter-pattern '[version, account, eni, source, destination, srcport, destport="22", protocol, packets, bytes, windowstart, windowend, action="ACCEPT", flowlogstatus]' \
  --start-time $(date -d '2 hours ago' +%s)000 \
  --end-time $(date +%s)000 \
  --output json | jq -r '.events[] | 
    (.timestamp | . / 1000 + 28800 | strftime("%Y-%m-%d %H:%M:%S")) + " - " + 
    .message'
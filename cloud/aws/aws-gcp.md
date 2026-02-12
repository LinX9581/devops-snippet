
* snapshot
aws snapshot 要先建立成 ami 才能建立成 instance
gcp snapshot 可以直接建立成 instance

aws 快照排程叫 dlm 是根據 disk tags 去識別要不要快照排程

* gcp lb 
aws alb(要設定兩個 vpc) -> ec2
gcp lb(只要一個 vpc) -> instance

* ssh 
由 AWS 管理公鑰 再自行用私鑰連線
GCP 則是自己產生公私鑰再上傳公鑰到 GCP
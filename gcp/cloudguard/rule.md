
# henna monntai
已關機的VM 一樣會報資安問題 (怕有權限的VM遠端開啟 再遠端入侵)
報一堆90天未登入的帳戶

1. 網路相關
Ensure Private Google Access is enabled for all subnetworks in VPC Network
https://gsl.dome9.com/D9.GCP.NET.14.html
在 vpc 子網路按編輯
private-google-access開啟後 VM如果只有內部IP 一樣能打 Google API
https://cloud.google.com/vpc/docs/private-google-access

Ensure 'Block Project-wide SSH keys' enabled for VM instances
Google IAP's ip range 就是很廣

Ensure that Compute instances do not have public IP addresses , Ensure that Cloud SQL instances do not have public IPs
關掉VM SQL 的外部 IP

Ensure that the Cloud SQL database instance requires all incoming connections to use SSL
關掉 sql 外部IP

2. 加密相關
Ensure VM disks for critical VMs are encrypted with Customer-Supplied Encryption Keys (CSEK)
建立硬碟時 請加密

Ensure that Compute instances have Confidential Computing enabled
建vm時 Confidential Computing enabled 要勾
確保資料傳輸時加密 且不收費 但會損失 0~6%的效能
https://gsl.dome9.com/D9.GCP.CRY.09.html
https://cloud.google.com/compute/confidential-vm/docs/about-cvm?authuser=1&_ga=2.188831464.-237547191.1628068054&_gac=1.125841663.1651634165.Cj0KCQjwpcOTBhCZARIsAEAYLuUPc-RheLIb8vUuiTASJ1o30gICzzM64bY7H3V8iA9OYsbIVvEC7oMaAhgxEALw_wcB


3. API Key 相關
Ensure API keys are not created for a project
請把 Api Key刪除

Ensure API keys are restricted to only APIs that application needs access
as same

Ensure API keys are rotated every 90 days , Ensure User-Managed/External Keys for Service Accounts Are Rotated Every 90 Days or Fewer
90天換一次 Api Key , SA Key

4. 權限相關
Ensure that Service Account has no Admin privileges
SA 不應該是 owner

Ensure that instances are not configured to use the default service account
https://gsl.dome9.com/D9.GCP.IAM.21.html
gce -> 編輯 -> Identity and API access -> 改成自己建立的 iam帳戶
預設的iam帳戶 權限太大

Ensure that corporate login credentials are used
IAM 不應該有個人信箱 *@gmail.com

Ensure that multi-factor authentication is enabled for all non-service accounts
所有帳號 都要二階段認證
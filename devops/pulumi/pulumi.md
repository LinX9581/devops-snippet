
https://www.pulumi.com/docs/clouds/gcp/get-started/create-project/

* pulumi init

pulumi new gcp-typescript
會要求註冊 app.pulumi.com 會把設定檔存在上面

project name        -> pulumi 專案名稱
stack name (dev):   -> 選dev
gcp:project: The Google Cloud project to deploy into:   -> 選 GCP 專案ID

* import firewall
gcloud compute firewall-rules list
pulumi import gcp:compute/firewall:Firewall prod_fn_eclipse_http 5190471277906065415

但要手動貼程式碼到 index.ts

* 查詢每個import進去的內容
pulumi stack export

* 刪除 import 的內容
pulumi state delete 'urn:pulumi:stack-name::project_name::gcp:compute/firewall:Firewall::5190471277906065415'


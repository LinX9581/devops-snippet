## 以下是 Cloud SQL 的 audit 設定
需要開啟
iam -> audit -> cloud sql 每個服務都有以下三個選項
編輯 Cloud SQL 屬於 System event 預設就會記錄
只開 Admin Read 👉 只能監控誰查詢了 Cloud SQL 設定 (修改設定屬於 System Event 預設就有了)
只開 Data Read 👉 只能監控誰讀取了資料，但不記錄寫入行為 (特定用戶 Select Show mysqldump)
只開 Data Write 👉 只能監控誰改變了資料，但不記錄讀取行為 (特定用戶 Delete Update 等等)
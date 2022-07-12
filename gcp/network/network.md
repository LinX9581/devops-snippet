# VPC NETWORK PEERING
要對連的專案彼此都要建立對等連接 並開通22&IP 才能網內互連
1. 先到pvc
2. 進私人服務連線建立 分配的服務IP範圍
3. 再到私人服務連線指派新增的IP 
# 多個無對外IP的VM 共用同一個對外IP
建立 cloud nat 綁定自訂網域、自訂IP
建立 cloud router
找不到IP 先從外部IP的服務找

此時每個VM curl其他網站記錄的IP都會是同一個
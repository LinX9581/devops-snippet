1. kube-apiserver
每個kubectl指令都會經過這裡，再到各個Node

2. etcd
存放cluster的資料，當Master掛了就會備份

3. kube-controller-manager
監視每個 cluster的狀態

4. kube-scheduler
會讓pod跑到最適合的node

下新增pod的指令 -> 1 -> 3(判斷資源許可就建立) -> 4(有新的pod就送到對應node)
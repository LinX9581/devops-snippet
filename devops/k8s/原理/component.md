https://ithelp.ithome.com.tw/articles/10264285

* cluster組成
Node包含pod
pod 包含1個或多個container
每個pod會有一組浮動IP
需要靠service固定pod IP
當service很多個時 再透過ingress做附載平衡

* node 組成
1. container runtime
負責運行container
2. kubelet
負責建構 Pod 還有維護 Container 正常運行
kubelet會與Container還有node相互溝通,
每當Pod的規格變更, kubelet就會依照Pod的規格跟現行情況變更Pod內部的container配置
3. kube-proxy
負責處理Node間網路規則管理,提供Pod之間溝通的管道

* pod運作方式
1. kube-apiserver
每個kubectl指令都會經過這裡，再到各個Node
2. etcd
存放cluster的資料，當Master掛了就會備份
3. kube-controller-manager
監視每個 cluster的狀態
-> kube-scheduler -> kubelet -> pod
4. kube-scheduler
會讓pod跑到最適合的node

下新增pod的指令 -> 1 -> 3(判斷資源許可就建立) -> 4(有新的pod就送到對應node)

# service
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-service-%E7%AF%87-d19d4c6e945f

# ingress
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%B8%80-92944d4bf97d
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%BA%8C-559c7a41404b
# 原理
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
* old
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%B8%80-92944d4bf97d
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%BA%8C-559c7a41404b

* new
https://ithelp.ithome.com.tw/articles/10288843
* SSL
https://fufu.gitbook.io/kk8s/task-memory/23.ingress-ssl-secret

# nginx ingress
https://github.com/kubernetes/ingress-nginx

# 進階設定
三者基本一樣 
* deployment    //normal 用來建構無狀態Pod
* daemonset     //殺掉會重生  //應該是差在pod ID 會不會被更換
* stateful      //殺掉會原地重生 用來建構有狀態Pod

# scaling 
vertical        //調整cpu & ram
horizontal      //可設最小&最大產生Pod
health-check    


設定檔範例參考
https://ithelp.ithome.com.tw/articles/10263702

概念界介紹
https://jimmysong.io/kubernetes-handbook/concepts/pod-overview.html

入門到進階到課程
https://www.hwchiu.com/


# Dashboard
* 參考
https://kubernetes.io/docs/reference/access-authn-authz/authentication/
https://ithelp.ithome.com.tw/articles/10287935

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml

IP:PORT/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'
卡在沒token
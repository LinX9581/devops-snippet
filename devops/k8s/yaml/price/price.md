* GKE Standard 
一個cluster 0.1USD/1h
GKE免費額度 會剛好抵掉

node計費
每個node 會建一台GCE VM


* GKE Autopilot
0.1USD/1h
pod使用的CPU 記憶體計費
https://cloud.google.com/kubernetes-engine/pricing?authuser=2&_ga=2.260273486.-237547191.1628068054

要讓pod 用spot的方式建立 會省很多
https://cloud.google.com/kubernetes-engine/docs/how-to/autopilot-spot-pods?hl=zh-cn
但目前怎麼建 都pending


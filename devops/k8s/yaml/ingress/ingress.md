# 參考
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%B8%80-92944d4bf97d
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%BA%8C-559c7a41404b

官方
https://kubernetes.io/docs/concepts/services-networking/ingress/

# 建立
kcy deploy.yaml
kcy ingress.yaml
kcy ingress.yaml
* 注意版本 要對應k8s版本
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml

kubectl get all -n ingress-nginx
刪除則 kcy -> kdy


# 原理

可以綁定DNS
並根據$uri 來判斷要連到哪個 service
要注意 一般的ingress A路徑 只會連到 service 的A路徑
所以多路徑 就要寫多個rule
或透過 nginx controller

blue.linx.website/blue -> blue-service/blue
ex.
  rules:
  - host: blue.linx.website
    http:
      paths:
      - path: /blue
        pathType: Prefix  
        backend:
          service:
            name: blue-service
            port:
              number: 3000

實際上會建立 GCP Loadbalancer
連規則都會一併建立完成
如果刪除 ingress 則 GCP Loadbalancer 跟著刪除
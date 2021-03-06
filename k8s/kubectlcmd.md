## minikube 相關指令
* minikube ip
* minikube ssh
* minikube dashboard //開啟後 GKE 即可監控

## kubectl 相關指令
sudo apt-get install kubectl
## API
* kubectl proxy // curl 127.0.0.1:8001 可查看有哪些API可用
* gcloud container clusters get-credentials cluster-4 --zone=asia-east1-a --project=k88888888s-329606
* kubectl exec --stdin --tty hello -- /bin/bash     //連到VM
* kubectl expose deploy hello-deployment --type=NodePort --name=my-deployment-service   //建立service 需要先建立deployment
kubectl expose deployment hello-deployment --type=LoadBalancer --name=my-service
## 查詢
* kubectl get pods --namespace=namespace
* kubectl get services --namespace=production
* kubectl get pods web -o jsonpath --template={.status.podIP} //查IP
* kubectl logs podname                  //查看pod log
* kubectl describe pods podname --namespace=develop
* kubectl describe no minikube          //查看pod cpu ram ip
* kubectl describe rc                   //查看replica set

## 新增
* kubectl run nginx --image=nginx       //終端機執行名稱=nginx
* kubectl apply -f pod.yaml             //建完後 ssh minukube 會看到新增的container
* kubectl create namespace develop      //每個namespace可以隔離環境


## 移除
* kubectl delete -f pod.yaml
* kubectl delete pods podname --namespace=develop
* kubectl delete deployment depname
* kubectl delete rc rcname
* kubectl delete svc svcname

## 對外
* kubectl port-forward my-helloworld 3333:3000   //只能curl 127.0.0.1:3333 外部無法連
* minikube service my-deployment-service --url   //讓建立的service 對外
## 監控
kubectl top pod podname

從節點拔除
* kubectl uncordon podname

新增節點
* kubectl cordon podname

# 啟用deployment
kubectl apply -f /k8s/dev.yaml

# 以該deployment 建立service
kubectl expose deploy hello-deployment --type=NodePort --name=my-deployment-service

# 讓該service 對外
minikube service my-deployment-service --url

# 更新原來的deployment
他會新增新的Pod來取代舊的 
[yaml 上的container name] = [dockerhub上的image name]
my-pod=zxcvbnius/docker-demo:v2.0.0
kubectl set image deploy/hello-deployment my-pod=zxcvbnius/docker-demo:v2.0.0

# 可以看到版本紀錄
kubectl rollout history deploy hello-deployment

# 到前一版
kubectl rollout undo deployment hello-deployment

# 到第三版
kubectl rollout undo deploy hello-deployment --to-revision=3

# 停止
kubectl rollout pause deployment/helloworld-deployment
kubectl rollout resume deployment/helloworld-deployment

# 更改效能配置
kubectl set resources deployment helloworld-deployment --limits=cpu=200m,memory=512Mi
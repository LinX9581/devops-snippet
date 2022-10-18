
# 檢查狀態
kubectl get statefulsets.apps

# 增加成5個
kubectl scale statefulset --replicas 5 helloworld-statefulset

# 更新版本
kubectl set image statefulset/helloworld-statefulset k8s-demo=105552010/k8s-demo:v2

# 檢查狀態
kubectl rollout status statefulset helloworld-statefulset

# 降版
kubectl rollout undo statefulsets.apps helloworld-statefulset


# 他跟deploy差在他沒有 Pause & resume 指令
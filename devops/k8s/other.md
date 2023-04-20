
# Location Type
* Zonal 單一區 死了就沒
* Regional 多區
可以設定一個Zone要幾個node
預設3個Zone 個別建立3個node 共9個node
一個node規格 e2-medium 費用 28.32*9=254.88


# ref
從題目講解
https://ithelp.ithome.com.tw/users/20129600/ironman/3179?page=2

pv pvc
https://kubernetes.io/zh-cn/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
https://medium.com/k8s%E7%AD%86%E8%A8%98/kubernetes-k8s-pv-pvc-%E5%84%B2%E5%AD%98%E5%A4%A7%E5%B0%8F%E4%BA%8B%E4%BA%A4%E7%B5%A6pv-pvc%E7%AE%A1%E7%90%86-4d412b8bafb5

https://medium.com/k8s%E7%AD%86%E8%A8%98/kubernetes-k8s-%E8%B3%87%E6%96%99%E4%B8%8D%E8%83%BD%E6%8E%89-volume-e57de55a5142


# alias
nano ~/.bashrc

alias k='kubectl'
## get
alias kgp='kubectl get pod -o wide'
alias kgn='kubectl get node'
alias kgnd='kubectl get node -o wide'
alias kgd='kubectl get deployment'
alias kgs='kubectl get service'
alias kgh='kubectl get HorizontalPodAutoscaler'
alias kgl='kubectl logs'
alias kgr='kubectl get rs'
alias kgd='kubectl get deployment'
alias kgi='kubectl get ingress'
alias kgc='kubectl get configmap'

## create
alias kcy='kubectl apply -f'

## describe
alias kdsp='kubectl describe pod'
alias kdsn='kubectl describe node'
alias kdsd='kubectl describe deployment'
alias kdss='kubectl describe service'
alias kdsh='kubectl describe HorizontalPodAutoscaler'
alias kdsi='kubectl describe ingress'
alias kdsc='kubectl describe configmap'

## delete
alias kdd='kubectl delete deployment'
alias kds='kubectl delete service'
alias kdh='kubectl delete HorizontalPodAutoscaler'
alias kdn='kubectl delete node'
alias kdp='kubectl delete pod'

## ssh
alias kssh='kubectl exec --stdin --tty'
kubectl exec -it web -- /bin/bash
## monit
alias ktp='kubectl top pod'
alias ktn='kubectl top node'
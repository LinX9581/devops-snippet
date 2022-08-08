alias k8s='kubectl'
## get
alias kgp='kubectl get pod -o wide'
alias kgn='kubectl get node'
alias kgd='kubectl get deployment'
alias kgs='kubectl get service'
alias kgh='kubectl get HorizontalPodAutoscaler'
alias kgl='kubectl logs'
alias kgr='kubectl get rs'
alias kgd='kubectl get deployment'

## create
alias kcy='kubectl apply -f'

## describe
alias kdsp='kubectl describe pod'
alias kdsn='kubectl describe node'
alias kdsd='kubectl describe deployment'
alias kdss='kubectl describe service'
alias kdsh='kubectl describe HorizontalPodAutoscaler'

## delete
alias kdd='kubectl delete deployment'
alias kds='kubectl delete service'
alias kdh='kubectl delete HorizontalPodAutoscaler'
alias kdn='kubectl delete node'
alias kdp='kubectl delete pod'

## monit
alias ktp='kubectl top pod'
alias ktn='kubectl top node'
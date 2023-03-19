
# port-forward
是在執行這段指令的VM 讓VM的port轉發到pod的port
kubectl port-forward --address 0.0.0.0 deployment1-86565d98c5-jb2lj 3007:3005 -n ingress-nginx


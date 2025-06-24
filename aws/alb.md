* 檢查目前 ALB 狀態
sudo aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,State.Code,DNSName,Scheme]' --output table
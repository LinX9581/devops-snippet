gcloud compute project-info add-metadata --metadata enable-oslogin=FALSE

* 打開特定VM的 oslogin , 打開後只有iam使用者可以連線 , 無法使用一般 SSH
gcloud compute instances add-metadata test-1 --metadata enable-oslogin=TRUE

gcloud compute os-login ssh-keys add --key-file /devops/tmp/id_rsa.pub --ttl 10d
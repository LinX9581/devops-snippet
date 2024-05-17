gcloud compute project-info add-metadata --metadata enable-oslogin=FALSE

gcloud compute instances add-metadata test-1 --metadata enable-oslogin=TRUE

gcloud compute os-login ssh-keys add --key-file /devops/tmp/id_rsa.pub --ttl 10d
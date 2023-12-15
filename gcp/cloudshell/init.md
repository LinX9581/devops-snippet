
gcloud auth activate-service-account --key-file json
gcloud config set project now-227907


gcloud compute instances list
gcloud compute firewall-rules list


* create network
gcloud compute networks create gcp-test --subnet-mode=custom
gcloud compute networks list

* create subnet
gcloud compute networks subnets create gcp-test-sub --network=gcp-test --range=172.19.1.0/24 --region=asia-east1 --enable-private-ip-google-access

* edit subnet , enable private ip access
gcloud compute networks subnets update gcp-test-sub --region=asia-east1 --enable-private-ip-google-access

* create firewall rule
gcloud compute firewall-rules create gcp-test-allow-http --network=gcp-test --allow tcp:80 --source-ranges=0.0.0.0/0
gcloud compute firewall-rules create gcp-test-allow-ssh --network=gcp-test --allow tcp:22 --source-ranges=0.0.0.0/0

* create vm (ubuntu20 ssd 10G e2-micro)
gcloud compute instances create gcp-test-vm \
  --zone=asia-east1-b \
  --machine-type=e2-micro \
  --subnet=gcp-test-sub \
  --image=ubuntu-2004-focal-v20231130 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-ssd \
  --boot-disk-device-name=gcp-test-vm 

* delete all of above
gcloud compute instances delete gcp-test-vm --zone=asia-east1-b
gcloud compute firewall-rules delete gcp-test-allow-http
gcloud compute firewall-rules delete gcp-test-allow-ssh
gcloud compute networks subnets delete gcp-test-sub --region=asia-east1
gcloud compute networks delete gcp-test

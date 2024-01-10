## GCS
gsutil ls
gsutil -m cp -r dir gs://my-bucket
gsutil ls -a gs://bobee-1

## iam
gcloud projects add-iam-policy-binding project_name --member="serviceAccount:analytics-apis@project_name.iam.gserviceaccount.com" --role="roles/storage.objectCreator"


## image 相關
```
gcloud compute images export \
    --image frankuse \
    --destination-uri gs://frankuse/frankuse.tar.gz \
    --project test-project \
    --zone asia-east1-a

gcloud beta compute machine-images create frankuse-image \
    --source-instance frankuse-snap

gcloud compute images list | grep ubuntu

```

## Log
gcloud logging read 'logName="projects/prod-salses-vote/logs/cloudaudit.googleapis.com%2Factivity" AND 
protoPayload.authenticationInfo.principalEmail="itrd@gmail.com"' --format json --project prod-salses-vote
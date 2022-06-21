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


# 

# create snapshot schedule
gcloud compute resource-policies create snapshot-schedule SCHEDULE_NAME \
    --description "MY DAILY SNAPSHOT SCHEDULE" \
    --max-retention-days 10 \
    --start-time 22:00 \
    --daily-schedule \
    --region us-west1 \
    --on-source-disk-delete keep-auto-snapshots \
    --snapshot-labels env=dev,media=images \
    --storage-location US

# disk add snaoshot schedule
gcloud compute disks add-resource-policies [DISK_NAME] \
    --resource-policies [SCHEDULE_NAME] \
    --zone [ZONE]
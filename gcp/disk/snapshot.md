# create snapshot schedule
gcloud compute resource-policies create snapshot-schedule hourly-snapshot \
    --region=asia-east1 \
    --max-retention-days=2 \
    --storage-location=asia-east1 \
    --on-source-disk-delete=keep-auto-snapshots \
    --hourly-schedule=1 \
    --start-time=00:00


# disk add snaoshot schedule
gcloud compute disks add-resource-policies [DISK_NAME] \
    --resource-policies [SCHEDULE_NAME] \
    --zone [ZONE]
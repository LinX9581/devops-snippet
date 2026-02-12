#!/bin/bash

# Replace Project ID
PROJECT_ID="linx"
SCHEDULE_NAME="hourly-snapshot"
ZONE="asia-east1-b"

gcloud config set project linx

gcloud compute resource-policies create snapshot-schedule hourly-snapshot \
    --region=asia-east1 \
    --max-retention-days=2 \
    --storage-location=asia-east1 \
    --on-source-disk-delete=keep-auto-snapshots \
    --hourly-schedule=1 \
    --start-time=00:00

# List all disks in the specified project and zone

DISKS=$(gcloud compute disks list --project="$PROJECT_ID" --zones="$ZONE" --format="value(name)")

# Loop through each disk and attach the resource policy
for DISK_NAME in $DISKS; do
  echo "Adding resource policy to disk: $DISK_NAME"
  
  gcloud compute disks add-resource-policies "$DISK_NAME" \
    --resource-policies="$SCHEDULE_NAME" \
    --zone="$ZONE"
done

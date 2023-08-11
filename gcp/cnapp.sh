#!/bin/bash
# Run a command and store its output in a variable
project=$(gcloud config get-value project)

# Check if the output is empty
if [ -z "$project" ]; then
  echo "Error: Project is empty"
  exit 1
fi

# Enable Compute Engine API and Cloud Storage service for each project
echo "Output: $project"
#gcloud services enable compute.googleapis.com storage-component.googleapis.com --project=$project
gcloud services enable compute.googleapis.com cloudresourcemanager.googleapis.com container.googleapis.com logging.googleapis.com dns.googleapis.com --project=$project
gcloud services enable cloudkms.googleapis.com iam.googleapis.com appengine.googleapis.com bigquery.googleapis.com admin.googleapis.com file.googleapis.com apikeys.googleapis.com --project=$project
gcloud services enable cloudfunctions.googleapis.com sqladmin.googleapis.com bigtableadmin.googleapis.com pubsub.googleapis.com redis.googleapis.com serviceusage.googleapis.com --project=$project
gcloud services enable cloudasset.googleapis.com essentialcontacts.googleapis.com accessapproval.googleapis.com --project=$project


# Set the service account name and desired role
SA_NAME="CloudGuard-Connect"
ROLE_1="roles/viewer"
ROLE_2="roles/iam.securityReviewer"
ROLE_3="roles/cloudasset.viewer"

# Create the service account
gcloud iam service-accounts create $SA_NAME --display-name "CloudGuard-Connect"

# Add the role to the service account
gcloud projects add-iam-policy-binding $project \
    --member="serviceAccount:$SA_NAME@$project.iam.gserviceaccount.com" \
    --role="$ROLE_1"
gcloud projects add-iam-policy-binding $project \
    --member="serviceAccount:$SA_NAME@$project.iam.gserviceaccount.com" \
    --role="$ROLE_2"
gcloud projects add-iam-policy-binding $project \
    --member="serviceAccount:$SA_NAME@$project.iam.gserviceaccount.com" \
    --role="$ROLE_3"

# Create the JSON file for the service account
gcloud iam service-accounts keys create cloudguard.json --iam-account $SA_NAME@$project.iam.gserviceaccount.com
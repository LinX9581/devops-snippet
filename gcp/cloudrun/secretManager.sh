
# create secret
echo -n "172.16.7.4" | gcloud secrets create CLIENT_DB_URL --project $CLIENT_DB_URL --data-file=-

# check secret and IAM policy
gcloud secrets versions access latest --secret=CLIENT_DB_URL
gcloud secrets get-iam-policy CLIENT_DB_URL

# check cloud run iam
gcloud run services describe stg-bn-news --region=asia-east1 --format="value(spec.template.spec.serviceAccountName)"
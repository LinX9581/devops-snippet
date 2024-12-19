# Variables
BUCKET_NAME="nn-gcs-test123"
BACKEND_BUCKET_NAME="eclipse-backend-bucket"
URL_MAP_NAME="eclipse-url-map"
HTTP_PROXY_NAME="eclipse-http-proxy"
FORWARDING_RULE_NAME="eclipse-http-rule"

# Set this to "Y" to create a new bucket and upload files
CREATE_BUCKET="N"  # Y or N

if [ "$CREATE_BUCKET" = "Y" ]; then
  LOCAL_DIRECTORY="/var/www/eclipse"
  MAIN_PAGE="index.html"
  ERROR_PAGE="404.html"
  echo "Creating bucket and uploading files..."
  # 1. Create bucket and upload files
  gcloud storage buckets create gs://$BUCKET_NAME
  gsutil cp -r $LOCAL_DIRECTORY gs://$BUCKET_NAME

  # 2. Set permissions and configure website
  gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME
  gsutil web set -m $MAIN_PAGE -e $ERROR_PAGE gs://$BUCKET_NAME
else
  echo "Skipping bucket creation and file upload."
fi

# 3. Create backend bucket
gcloud compute backend-buckets create $BACKEND_BUCKET_NAME --gcs-bucket-name $BUCKET_NAME

# 4. Create URL map
gcloud compute url-maps create $URL_MAP_NAME --default-backend-bucket $BACKEND_BUCKET_NAME

# 5. Create HTTP proxy
gcloud compute target-http-proxies create $HTTP_PROXY_NAME --url-map=$URL_MAP_NAME

# 6. Create forwarding rule
gcloud compute forwarding-rules create $FORWARDING_RULE_NAME --global --target-http-proxy=$HTTP_PROXY_NAME --ports=80

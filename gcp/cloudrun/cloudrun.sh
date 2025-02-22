GCP_PROJECT_NAME=
AR_PROJECT_NAME=
PROJECT_NAME=
APP_VERSION=$(date +"%m_%d_%H%M%S")

# gcloud auth activate-service-account --key-file $PROJECT_NAME.json
gcloud config set project $GCP_PROJECT_NAME
gcloud auth configure-docker $AR_TARGET
gcloud auth configure-docker --quiet
gcloud artifacts repositories create $AR_PROJECT_NAME --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION .
docker push asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION
# gcloud run deploy $CLOUDRUN_SERVICE \
#     --image=asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION \
#     --region=asia-east1 \
#     --platform=managed \
#     --allow-unauthenticated \
#     --memory=512Mi \
#     --cpu=1 \
#     --max-instances=3 \
#     --timeout=10m \
#     --concurrency=1 \
#     --set-env-vars=db_user=dev,db_password=00000000


# gcloud run services delete my-service5 --platform=managed --region=asia-east1
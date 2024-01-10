1. push to ar and deploy to cloud run

gcloud auth activate-service-account --key-file project-name.json
gcloud config set project project-name
gcloud auth configure-docker asia-docker.pkg.dev
gcloud artifacts repositories create nodejs-repo --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.5 . --no-cache
docker push asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.5
gcloud run deploy my-service --image=asia-docker.pkg.dev/project-name/nodejs-repo/nodejs-template:4.6 --region=asia-east1 --platform=managed --allow-unauthenticated --memory=512Mi --cpu=1 --max-instances=1 --timeout=10m --concurrency=1 --port=3005 --set-env-vars=NODE_ENV=production

有時候沒辦法佈署是因為記憶體不夠


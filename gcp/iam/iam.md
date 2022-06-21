## 加權限 cloud shell
要先 gcloud auth login 
gcloud projects add-iam-policy-binding iam-test-338508 \
  --member='user:linx9581@gmail.com' \
  --role='roles/storage.admin' \
  --role='roles/cloudbuild.builds.editor' \
  --role='roles/editor'

gcloud projects remove-iam-policy-binding iam-test-338508 \
  --member='user:shu575290@gmail.com' \
  --role='roles/editor'
  
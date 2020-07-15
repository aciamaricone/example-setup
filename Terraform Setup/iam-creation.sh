# Parameters
USER1=$1
TF_ADMIN_PROJECT=$2
HUB_PROJECT=$3
CLIENT_PROJECT=$4

# Store Project IDs for use in IAM assignment
TF_ADMIN_PROJECT_ID=`gcloud projects list | grep $TF_ADMIN_PROJECT | awk '{print $3}'`
HUB_PROJECT_ID=`gcloud projects list | grep $HUB_PROJECT | awk '{print $3}'`
CLIENT_PROJECT_ID=`gcloud projects list | grep $CLIENT_PROJECT | awk '{print $3}'`

# Assign Project Owner roles in order to enable ease of use for evaluation
gcloud projects add-iam-policy-binding $TF_ADMIN_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner
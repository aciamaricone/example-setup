# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3

# Enable appropriate product APIs
gcloud config set project $HUB_PROJECT
gcloud services enable \
bigquery.googleapis.com \
bigquerystorage.googleapis.com \
cloudbilling.googleapis.com \
cloudresourcemanager.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
containeranalysis.googleapis.com \
iam.googleapis.com \
iap.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com

gcloud config set project $CLIENT_1_PROJECT
gcloud services enable \
bigquery.googleapis.com \
bigquerystorage.googleapis.com \
cloudbilling.googleapis.com \
cloudresourcemanager.googleapis.com \
compute.googleapis.com \
iam.googleapis.com \
iap.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com

gcloud config set project $CLIENT_2_PROJECT
gcloud services enable \
bigquery.googleapis.com \
bigquerystorage.googleapis.com \
cloudbilling.googleapis.com \
cloudresourcemanager.googleapis.com \
compute.googleapis.com \
iam.googleapis.com \
iap.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com
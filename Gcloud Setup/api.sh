# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3

# Enable appropriate product APIs
# https://cloud.google.com/endpoints/docs/openapi/enable-api
gcloud config set project $HUB_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
containeranalysis.googleapis.com \
iap.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

gcloud config set project $CLIENT_1_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
iap.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

gcloud config set project $CLIENT_2_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
iap.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 
# Variables for use within script
HUB_PROJECT=$1
SHARED_SERVICES_FOLDER_ID=$2

CLIENT_PROJECT=$3
CLIENT_FOLDER=$4
BILLING_ID=$5
ORG_ID=$6




# Create new auto-modeling project
gcloud projects create $PROJECT_NAME \
--folder=$FOLDER_ID
gcloud beta billing projects link $PROJECT_NAME --billing-account=$BILLING_ID
gcloud config set project $PROJECT_NAME
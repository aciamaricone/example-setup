# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
SHARED_SERVICES_FOLDER=$8
CLIENT_1_FOLDER=$9
CLIENT_2_FOLDER=${10}
BILLING_ID=${11}

# Create Projects
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`
CLIENT_1_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_1_PROJECT | awk '{print $3}'`
CLIENT_2_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_2_PROJECT | awk '{print $3}'` 

gcloud projects create $HUB_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $HUB_PROJECT --billing-account=$BILLING_ID

gcloud projects create $CLIENT_1_PROJECT \
--folder=$CLIENT_1_FOLDER_ID
gcloud beta billing projects link $CLIENT_1_PROJECT --billing-account=$BILLING_ID

gcloud projects create $CLIENT_2_PROJECT \
--folder=$CLIENT_2_FOLDER_ID
gcloud beta billing projects link $CLIENT_2_PROJECT --billing-account=$BILLING_ID
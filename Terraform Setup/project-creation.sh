# Parameters
SHARED_SERVICES_FOLDER=$1
CLIENT_FOLDER=$2
TF_ADMIN_PROJECT=$3
HUB_PROJECT=$4
CLIENT_PROJECT=$5
BILLING_ID=$6

# Store Folder IDs for use in project creation
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`
CLIENT_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_FOLDER | awk '{print $3}'`

# Create Terrform Admin Project
gcloud projects create $TF_ADMIN_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $TF_ADMIN_PROJECT --billing-account=$BILLING_ID

# Create Hub Project
gcloud projects create $HUB_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $HUB_PROJECT --billing-account=$BILLING_ID

# Create Client Project
gcloud projects create $CLIENT_PROJECT \
--folder=$CLIENT_FOLDER_ID
gcloud beta billing projects link $CLIENT_PROJECT --billing-account=$BILLING_ID

# Parameters
DOMAIN=$1
SHARED_SERVICES_FOLDER=$2
CLIENT_FOLDER=$3
HUB_PROJECT=$4
CLIENT_PROJECT=$5
BILLING_ID=$6

# Store organization ID for use in folder creation
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

# Create Shared Services Folder and store ID
gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER \
--organization=$ORG_ID
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`

# Create Client Folder and store ID
gcloud alpha resource-manager folders create \
--display-name=$CLIENT_FOLDER \
--organization=$ORG_ID
CLIENT_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_FOLDER | awk '{print $3}'`

# Create Hub Project
gcloud projects create $HUB_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $HUB_PROJECT --billing-account=$BILLING_ID

# Create Client Project
gcloud projects create $CLIENT_PROJECT \
--folder=$CLIENT_FOLDER_ID
gcloud beta billing projects link $CLIENT_PROJECT --billing-account=$BILLING_ID
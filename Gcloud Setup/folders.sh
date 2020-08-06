# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
SHARED_SERVICES_FOLDER=$8
CLIENT_1_FOLDER=$9
CLIENT_2_FOLDER=${10}
DOMAIN=acxiom.com

# Create Folders and store IDs
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER \
--organization=$ORG_ID
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`

gcloud alpha resource-manager folders create \
--display-name=$CLIENT_1_FOLDER \
--organization=$ORG_ID
CLIENT_1_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_1_PROJECT | awk '{print $3}'`

gcloud alpha resource-manager folders create \
--display-name=$CLIENT_2_FOLDER \
--organization=$ORG_ID
CLIENT_2_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_2_PROJECT | awk '{print $3}'`
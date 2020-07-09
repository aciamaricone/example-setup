# Parameters
export DOMAIN=$1
export SHARED_SERVICES_FOLDER=$2
export CLIENT_FOLDER=$3

# Store organization ID for use in folder creation
export ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

#Create Shared Services Folder
gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER
--organization=$ORG_ID

#Create Client Folder
gcloud alpha resource-manager folders create \
--display-name=$CLIENT_FOLDER
--organization=$ORG_ID

#Store Folder IDs
export SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`
export CLIENT_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_FOLDER | awk '{print $3}'`
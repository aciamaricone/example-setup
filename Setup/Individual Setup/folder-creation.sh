# Parameters
DOMAIN=$1
SHARED_SERVICES_FOLDER=$2
CLIENT_FOLDER=$3

# Store Organization ID for use in folder creation
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

# Create Shared Services Folder and store ID
gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER \
--organization=$ORG_ID

# Create Client Folder and store ID
gcloud alpha resource-manager folders create \
--display-name=$CLIENT_FOLDER \
--organization=$ORG_ID
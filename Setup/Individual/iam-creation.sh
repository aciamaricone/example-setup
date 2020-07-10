# Parameters
USER1=$1
HUB_PROJECT=$2
CLIENT_PROJECT=$3

# Store Project IDs for use in IAM assignment
HUB_PROJECT_ID=`gcloud projects list | grep $HUB_PROJECT | awk '{print $3}'`
CLIENT_PROJECT_ID=`gcloud projects list | grep $CLIENT_PROJECT | awk '{print $3}'`

# Assign Project Owner roles in order to enable ease of use for evaluation
gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner
# Variables
HUB_PROJECT=$1
JENKINS_SA=jenkins-sa
JENKINS_SA_FULL="$JENKINS_SA@$HUB_PROJECT.iam.gserviceaccount.com"

# Pull in images to Container Registry for Hub Project
gcloud config set project $HUB_PROJECT
gcloud iam service-accounts create $JENKINS_SA --display-name "Jenkins Service Account"
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$JENKINS_SA_FULL \
--role=roles/storage.admin
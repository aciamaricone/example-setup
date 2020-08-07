# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
JENKINS_SA=jenkins-sa
JENKINS_SA_FULL="$JENKINS_SA@$HUB_PROJECT.iam.gserviceaccount.com"

# Pull in images to Container Registry for Hub Project
# https://medium.com/google-cloud/how-to-push-docker-image-to-google-container-registry-gcr-through-jenkins-job-52b9d5ce9f7f
# https://plugins.jenkins.io/google-container-registry-auth/
gcloud iam service-accounts create $JENKINS_SA --display-name "Jenkins Service Account"
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$JENKINS_SA_FULL \
--role=roles/storage.admin
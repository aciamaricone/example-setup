# Variables
HUB_PROJECT=udl-control-hub-phase1
CLIENT_1_PROJECT=udl-core-sandbox-1
CLIENT_2_PROJECT=udl-core-sandbox-2
USER1=aciamaricone@google.com
JENKINS_SA=jenkins-sa
JENKINS_SA_FULL="$JENKINS_SA@$HUB_PROJECT.iam.gserviceaccount.com"

# Pull in images to Container Registry for Hub Project
# https://medium.com/google-cloud/how-to-push-docker-image-to-google-container-registry-gcr-through-jenkins-job-52b9d5ce9f7f
# https://plugins.jenkins.io/google-container-registry-auth/
gcloud iam service-accounts create $JENKINS_SA --display-name "Jenkins Service Account"

cd ~/$USER
mkdir temp_key
gcloud iam service-accounts keys create ~/$USER/temp_key --iam-account=$JENKINS_SA_FULL --key-file-type=json

gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$JENKINS_SA_FULL \
--role=roles/storage.admin
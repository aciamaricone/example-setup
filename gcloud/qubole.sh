# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
QUBOLE_CLIENT_1_SA=qubole-sa
QUBOLE_CLIENT_1_SA_FULL="$QUBOLE_CLIENT_1_SA@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
QUBOLE_CLIENT_2_SA=qubole-sa
QUBOLE_CLIENT_2_SA_FULL="$QUBOLE_CLIENT_2_SA@$CLIENT_2_PROJECT.iam.gserviceaccount.com"

# Create Qubole Service Accounts for Client Projects
# https://docs-gcp.qubole.com/en/latest/quick-start-guide/GCP-quick-start-guide/setup_procedures/automated_setup.html
gcloud config set project $CLIENT_1_PROJECT
gcloud iam service-accounts create $QUBOLE_CLIENT_1_SA --display-name "Qubole Service Account"
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_1_SA_FULL \
--role=roles/iam.serviceAccountAdmin
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_1_SA_FULL \
--role=roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_1_SA_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_1_SA_FULL \
--role=roles/iam.roleAdmin

gcloud config set project $CLIENT_2_PROJECT
gcloud iam service-accounts create $QUBOLE_CLIENT_2_SA --display-name "GKE Service Account"
gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_2_SA_FULL \
--role=roles/iam.serviceAccountAdmin
gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_2_SA_FULL \
--role=roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_2_SA_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=serviceAccount:$QUBOLE_CLIENT_2_SA_FULL \
--role=roles/iam.roleAdmin
# Parameters
DOMAIN=ciamaricone.com
SHARED_SERVICES_FOLDER=shared_services
CLIENT_FOLDER=client
HUB_PROJECT=acxiom-hub-demo
CLIENT_PROJECT=acxiom-customer-demo
CLIENT_PROJECT_2=acxiom-customer-demo-2
BILLING_ID=01AFB2-4ED2E6-628482	
USER1=aciamaricone@google.com

# Variables
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
HUB_PROJECT_SUBNET_RANGE=192.168.1.0/24
REGION=us-central1
CLIENT_PROJECT_SUBNET="$CLIENT_PROJECT"-central-subnet
CLIENT_PROJECT_SUBNET_RANGE=10.0.2.0/24
CLIENT_PROJECT_2_SUBNET="$CLIENT_PROJECT_2"-central-subnet
CLIENT_PROJECT_2_SUBNET_RANGE=10.0.1.0/24
HUB_PROJECT_CLUSTER="$HUB_PROJECT"-cluster
GKE_DATASET=gke_usage_metering
bq --location=US mk $GKE_DATASET
RAW_SB="$CLIENT_PROJECT"_raw
TRUSTED_SB="$CLIENT_PROJECT"_trusted
ACTIVATED_SB="$CLIENT_PROJECT"_activated
QUBOLE_SB="$CLIENT_PROJECT"_qubole
RAW_SB_2="$CLIENT_PROJECT_2"_raw
TRUSTED_SB_2="$CLIENT_PROJECT_2"_trusted
ACTIVATED_SB_2="$CLIENT_PROJECT_2"_activated
QUBOLE_SB_2="$CLIENT_PROJECT_2"_qubole

# Store organization ID for use in folder creation
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

# Create Folders and store IDs
# https://cloud.google.com/sdk/gcloud/reference/alpha/resource-manager/folders/list
gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER \
--organization=$ORG_ID
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`

gcloud alpha resource-manager folders create \
--display-name=$CLIENT_FOLDER \
--organization=$ORG_ID
CLIENT_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_FOLDER | awk '{print $3}'`

# Create Projects
# https://cloud.google.com/sdk/gcloud/reference/projects/create
gcloud projects create $HUB_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $HUB_PROJECT --billing-account=$BILLING_ID
HUB_PROJECT_ID=`gcloud projects list | grep $HUB_PROJECT | awk '{print $3}'`

gcloud projects create $CLIENT_PROJECT \
--folder=$CLIENT_FOLDER_ID
gcloud beta billing projects link $CLIENT_PROJECT --billing-account=$BILLING_ID
CLIENT_PROJECT_ID=`gcloud projects list | grep $CLIENT_PROJECT | awk '{print $3}'`

gcloud projects create $CLIENT_PROJECT_2 \
--folder=$CLIENT_FOLDER_ID
gcloud beta billing projects link $CLIENT_PROJECT_2 --billing-account=$BILLING_ID
CLIENT_PROJECT_2_ID=`gcloud projects list | grep $CLIENT_PROJECT_2 | awk '{print $3}'`

# Assign Project Owner roles in order to enable ease of use for evaluation
# https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding
gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_2_ID \
--member=user:$USER1 \
--role=roles/owner

# Enable appropriate product APIs
# https://cloud.google.com/endpoints/docs/openapi/enable-api
gcloud config set project $HUB_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
containeranalysis.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

gcloud config set project $CLIENT_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

gcloud config set project $CLIENT_PROJECT_2
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

# Create Shared VPC network for Projects
# https://cloud.google.com/vpc/docs/provisioning-shared-vpc#gcloud_1
gcloud compute networks create $HUB_PROJECT_VPC \
--project=$HUB_PROJECT \
--subnet-mode=custom \
--bgp-routing-mode=regional

gcloud compute networks subnets create $HUB_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$HUB_PROJECT_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create $CLIENT_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$CLIENT_PROJECT_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create $CLIENT_PROJECT_2_SUBNET \
--project=$HUB_PROJECT \
--range=$CLIENT_PROJECT_2_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute shared-vpc enable $HUB_PROJECT_ID
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_PROJECT
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_PROJECT_2

# Create Google Kubernetes Engine instance for Hub Project
# https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
gcloud beta container --project $HUB_PROJECT \
clusters create $HUB_PROJECT_CLUSTER \
--region $REGION \
--no-enable-basic-auth \
--release-channel "regular" \
--machine-type "e2-medium" \
--image-type "COS" \
--disk-type "pd-standard" \
--disk-size "100" \
--node-labels env=prod
--metadata disable-legacy-endpoints=true \
--scopes "https://www.googleapis.com/auth/cloud-platform" \
--num-nodes "3" \
--enable-stackdriver-kubernetes \
--enable-ip-alias \
--network "projects/$HUB_PROJECT/global/networks/$HUB_PROJECT_VPC" \
--subnetwork "projects/$HUB_PROJECT/regions/$REGION/subnetworks/$HUB_PROJECT_SUBNET" \
--enable-intra-node-visibility \
--default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "5" \
--enable-network-policy \
--no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,CloudRun,NodeLocalDNS \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--maintenance-window-start "2020-07-08T06:00:00Z" \
--maintenance-window-end "2020-07-09T06:00:00Z" \
--maintenance-window-recurrence "FREQ=WEEKLY;BYDAY=SA,SU" \
--enable-vertical-pod-autoscaling \
--resource-usage-bigquery-dataset $GKE_DATASET \
--enable-resource-consumption-metering \
--identity-namespace "$HUB_PROJECT.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot

# Create Google Cloud Storage buckets for Client Project
# https://cloud.google.com/storage/docs/creating-buckets#storage-create-bucket-gsutil
gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$RAW_SB
gsutil versioning set on gs://$RAW_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$TRUSTED_SB
gsutil versioning set on gs://$TRUSTED_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$ACTIVATED_SB
gsutil versioning set on gs://$ACTIVATED_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$QUBOLE_SB
gsutil versioning set on gs://$QUBOLE_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT_2 gs://$RAW_SB_2
gsutil versioning set on gs://$RAW_SB_2

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT_2 gs://$TRUSTED_SB_2
gsutil versioning set on gs://$TRUSTED_SB_2

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT_2 gs://$ACTIVATED_SB_2
gsutil versioning set on gs://$ACTIVATED_SB_2

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT_2 gs://$QUBOLE_SB_2
gsutil versioning set on gs://$QUBOLE_SB_2
# Parameters
DOMAIN=$1
SHARED_SERVICES_FOLDER=$2
CLIENT_FOLDER=$3
HUB_PROJECT=$4
CLIENT_PROJECT=$5
BILLING_ID=$6
USER1=$7

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
HUB_PROJECT_ID=`gcloud projects list | grep $HUB_PROJECT | awk '{print $3}'`

# Create Client Project
gcloud projects create $CLIENT_PROJECT \
--folder=$CLIENT_FOLDER_ID
gcloud beta billing projects link $CLIENT_PROJECT --billing-account=$BILLING_ID
CLIENT_PROJECT_ID=`gcloud projects list | grep $CLIENT_PROJECT | awk '{print $3}'`

# Assign Project Owner roles in order to enable ease of use for evaluation
gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

# Assign Project Owner roles in order to enable ease of use for evaluation
gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

# Enable appropriate product APIs
gcloud config set project $HUB_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
containeranalysis.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

# Create custom VPC network for Hub Project
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
SUBNET_RANGE=192.168.1.0/24
REGION=us-central1

gcloud compute networks create $HUB_PROJECT_VPC \
--project=$HUB_PROJECT \
--subnet-mode=custom \
--bgp-routing-mode=regional

gcloud compute networks subnets create $HUB_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

# Create Google Kubernetes Engine instance for Hub Project
HUB_PROJECT_CLUSTER="$HUB_PROJECT"-cluster
GKE_DATASET=gke_usage_metering

bq --location=US mk $GKE_DATASET

gcloud beta container --project $HUB_PROJECT \
clusters create $HUB_PROJECT_CLUSTER \
--region $REGION \
--no-enable-basic-auth \
--release-channel "regular" \
--machine-type "e2-medium" \
--image-type "COS" \
--disk-type "pd-standard" \
--disk-size "100" \
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

# Enable appropriate product APIs
gcloud config set project $CLIENT_PROJECT
gcloud services enable \
compute.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

# Create custom VPC network for Client Project
CLIENT_PROJECT_VPC="$CLIENT_PROJECT"-vpc
CLIENT_PROJECT_SUBNET="$CLIENT_PROJECT"-central-subnet
SUBNET_RANGE=10.0.1.0/24
REGION=us-central1

gcloud compute networks create $CLIENT_PROJECT_VPC \
--project=$CLIENT_PROJECT \
--subnet-mode=custom \
--bgp-routing-mode=regional

gcloud compute networks subnets create $CLIENT_PROJECT_SUBNET \
--project=$CLIENT_PROJECT \
--range=$SUBNET_RANGE \
--network=$CLIENT_PROJECT_VPC \
--region=$REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

# Create Google Cloud Storage buckets for Client Project
RAW_SB="$CLIENT_PROJECT"_raw
TRUSTED_SB="$CLIENT_PROJECT"_trusted
ACTIVATED_SB="$CLIENT_PROJECT"_activated

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$RAW_SB
gsutil versioning set on gs://$RAW_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$TRUSTED_SB
gsutil versioning set on gs://$TRUSTED_SB

gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$ACTIVATED_SB
gsutil versioning set on gs://$ACTIVATED_SB
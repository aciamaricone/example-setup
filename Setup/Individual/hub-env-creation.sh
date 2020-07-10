# Parameters
HUB_PROJECT=$1

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
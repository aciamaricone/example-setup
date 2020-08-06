# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
USE_REGION=$4
GKE_SA=gke-sa
GKE_SA_FULL="$GKE_SA@$HUB_PROJECT.iam.gserviceaccount.com"
HUB_PROJECT_CLUSTER="$HUB_PROJECT"-cluster
GKE_DATASET=gke_usage_metering

# Create Google Kubernetes Engine instance for Hub Project
gcloud config set project $HUB_PROJECT
gcloud iam service-accounts create $GKE_SA --display-name "GKE Service Account"
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$GKE_SA_FULL \
--role=roles/owner
bq --location=US mk $GKE_DATASET

gcloud container --project $HUB_PROJECT clusters create $HUB_PROJECT_CLUSTER \
--region $USE_REGION \
--no-enable-basic-auth \
--release-channel "regular" \
--machine-type "n2-standard-2" \
--image-type "COS" \
--disk-type "pd-standard" \
--disk-size "100" \
--node-labels env=poc \
--metadata disable-legacy-endpoints=true \
--service-account "$GKE_SA_FULL" \
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
--no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,CloudRun,NodeLocalDNS \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 2 \
--max-unavailable-upgrade 0 \
--maintenance-window-start "2020-07-08T06:00:00Z" \
--maintenance-window-end "2020-07-09T06:00:00Z" \
--maintenance-window-recurrence "FREQ=WEEKLY;BYDAY=SA,SU" \
--enable-vertical-pod-autoscaling \
--resource-usage-bigquery-dataset $GKE_DATASET \
--enable-network-egress-metering \
--enable-resource-consumption-metering \
--identity-namespace "$HUB_PROJECT.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot
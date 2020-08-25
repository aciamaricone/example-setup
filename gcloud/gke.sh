# Variables
HUB_PROJECT=$1
USE_REGION=$4
GKE_SA=gke-sa
GKE_SA_FULL="$GKE_SA@$HUB_PROJECT.iam.gserviceaccount.com"
HUB_PROJECT_CLUSTER="$HUB_PROJECT"-cluster
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
GKE_DATASET=gke_usage_metering
MASTER_RANGE=10.0.0.0/28

# Create Google Kubernetes Engine instance for Hub Project
gcloud config set project $HUB_PROJECT
gcloud iam service-accounts create $GKE_SA --display-name "GKE Service Account"
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$GKE_SA_FULL \
--role=roles/owner
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$GKE_SA_FULL \
--role=roles/container.developer
bq --location=US mk $GKE_DATASET

gcloud container --project $HUB_PROJECT clusters create $HUB_PROJECT_CLUSTER \
--region $USE_REGION \
--no-enable-basic-auth \
--cluster-version "1.16.11-gke.5" \
--release-channel "regular" \
--machine-type "n1-standard-2" \
--image-type "COS" \
--disk-type "pd-standard" \
--disk-size "100" \
--metadata disable-legacy-endpoints=true \
--service-account $GKE_SA_FULL \
--num-nodes "1" \
--enable-stackdriver-kubernetes \
--enable-ip-alias \
--network "projects/$HUB_PROJECT/global/networks/$HUB_PROJECT_VPC" \
--subnetwork "projects/$HUB_PROJECT/regions/$USE_REGION/subnetworks/$HUB_PROJECT_SUBNET" \
--enable-intra-node-visibility \
--default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "3" \
--no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--resource-usage-bigquery-dataset $GKE_DATASET \
--enable-network-egress-metering \
--enable-resource-consumption-metering





gcloud beta container --project $HUB_PROJECT clusters create $HUB_PROJECT_CLUSTER-3 \
--region $USE_REGION \
--no-enable-basic-auth \
--cluster-version "1.16.11-gke.5" \
--release-channel "regular" \
--machine-type "n1-standard-2" \
--image-type "COS" \
--disk-type "pd-standard" \
--disk-size "100" \
--metadata disable-legacy-endpoints=true \
--service-account $GKE_SA_FULL \
--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--num-nodes "3" \
--enable-stackdriver-kubernetes \
--enable-private-nodes \
--enable-private-endpoint \
--master-ipv4-cidr $MASTER_RANGE \
--enable-ip-alias \
--network "projects/$HUB_PROJECT/global/networks/$HUB_PROJECT_VPC" \
--subnetwork "projects/$HUB_PROJECT/regions/$USE_REGION/subnetworks/$HUB_PROJECT_SUBNET" \
--enable-intra-node-visibility \
--default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "3" \
--enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,CloudRun \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--maintenance-window-start "2020-08-10T03:00:00Z" \
--maintenance-window-end "2020-08-10T15:00:00Z" \
--maintenance-window-recurrence "FREQ=WEEKLY;BYDAY=SA,SU" \
--resource-usage-bigquery-dataset $GKE_DATASET \
--enable-network-egress-metering \
--enable-resource-consumption-metering \
--workload-pool "$HUB_PROJECT.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot
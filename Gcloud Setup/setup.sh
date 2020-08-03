# Arguments
DOMAIN=acxiom.com
SHARED_SERVICES_FOLDER=shared_services
CLIENT_1_FOLDER=client_1
CLIENT_2_FOLDER=client_2
HUB_PROJECT=udl-control-hub-phase1
CLIENT_1_PROJECT=udl-core-sandbox-1
CLIENT_2_PROJECT=udl-core-sandbox-2
BILLING_ID=0111B9-D0C0B2-04DD65
USER1=blake.reed@acxiom.com

HUB_PROJECT=general-272722

# Variables
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
HUB_PROJECT_SUBNET_RANGE=10.1.0.0/21
USE_REGION=us-east4
EUW_REGION=europe-west1

CLIENT_1_PROJECT_SUBNET="$CLIENT_1_PROJECT"-central-subnet
CLIENT_1_PROJECT_SUBNET_RANGE=10.2.8.0/21
CLIENT_2_PROJECT_SUBNET="$CLIENT_2_PROJECT"-central-subnet
CLIENT_2_PROJECT_SUBNET_RANGE=10.2.16.0/21

GKE_SA=gke-sa
GKE_SA_FULL="$GKE_SA@$HUB_PROJECT.iam.gserviceaccount.com"
HUB_PROJECT_CLUSTER="$HUB_PROJECT"-cluster
GKE_DATASET=gke_usage_metering

CLIENT_1_RAW_SB="$CLIENT_1_PROJECT"_raw
CLIENT_1_TRUSTED_SB="$CLIENT_1_PROJECT"_trusted
CLIENT_1_ACTIVATED_SB="$CLIENT_1_PROJECT"_activated
CLIENT_1_QUBOLE_SB="$CLIENT_1_PROJECT"_qubole
CLIENT_1_EXTRACTION_SB="$CLIENT_1_PROJECT"_extraction
CLIENT_2_RAW_SB_2="$CLIENT_2_PROJECT"_raw
CLIENT_2_TRUSTED_SB_2="$CLIENT_2_PROJECT"_trusted
CLIENT_2_ACTIVATED_SB_2="$CLIENT_2_PROJECT"_activated
CLIENT_2_QUBOLE_SB_2="$CLIENT_2_PROJECT"_qubole
CLIENT_2_EXTRACTION_SB="$CLIENT_2_PROJECT"_extraction

JENKINS_SA="$HUB_PROJECT"-jenkins-sa
JENKINS_SA_FULL="$JENKINS_SA@$HUB_PROJECT.iam.gserviceaccount.com"

CLIENT_1_BASTION_IP="$CLIENT_1_PROJECT"-bastion-ip
CLIENT_2_BASTION_IP="$CLIENT_2_PROJECT"-bastion-ip
CLIENT_1_BASTION="$CLIENT_1_PROJECT"-bastion
CLIENT_2_BASTION="$CLIENT_2_PROJECT"-bastion
USE_ZONE=us-east4-b
EUW_REGION=europe-west1-b
CLIENT_1_BASTION_SA="$CLIENT_1_PROJECT"-bastion-sa
CLIENT_2_BASTION_SA="$CLIENT_2_PROJECT"-bastion-sa
CLIENT_1_BASTION_SA_FULL="$CLIENT_1_BASTION_SA@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
CLIENT_2_BASTION_SA_FULL="$CLIENT_2_BASTION_SA@$CLIENT_2_PROJECT.iam.gserviceaccount.com"

CLIENT_1_INSTANCE_TEMPLATE="$CLIENT_1_PROJECT"-instance-template
CLIENT_2_INSTANCE_TEMPLATE="$CLIENT_2_PROJECT"-instance-template
CLIENT_1_INSTANCE_GROUP="$CLIENT_1_PROJECT"-mig
CLIENT_2_INSTANCE_GROUP="$CLIENT_2_PROJECT"-mig
CLIENT_1_MIG_HEALTHCHECK="$CLIENT_1_INSTANCE_GROUP"-healtcheck
CLIENT_2_MIG_HEALTHCHECK="$CLIENT_2_INSTANCE_GROUP"-healtcheck
CLIENT_1_LB="$CLIENT_1_PROJECT"-lb
CLIENT_2_LB="$CLIENT_1_PROJECT"-lb
CLIENT_1_LB_HEALTHCHECK="$CLIENT_1_LB"-healtcheck
CLIENT_2_LB_HEALTHCHECK="$CLIENT_1_LB"-healtcheck
CLIENT_1_BACKEND="$CLIENT_1_PROJECT"-backend
CLIENT_2_BACKEND="$CLIENT_1_PROJECT"-backend
CLIENT_1_FORWARD_RULE_1="$CLIENT_1_PROJECT"-forwarding-rule-1
CLIENT_1_FORWARD_RULE_2="$CLIENT_1_PROJECT"-forwarding-rule-2
CLIENT_2_FORWARD_RULE_1="$CLIENT_2_PROJECT"-forwarding-rule-1
CLIENT_2_FORWARD_RULE_2="$CLIENT_2_PROJECT"-forwarding-rule-2

# Store organization ID for use in folder creation
ORG_ID=`gcloud organizations list | grep $DOMAIN | awk '{print $2}'`

# Create Folders and store IDs
# https://cloud.google.com/sdk/gcloud/reference/alpha/resource-manager/folders/list
gcloud alpha resource-manager folders create \
--display-name=$SHARED_SERVICES_FOLDER \
--organization=$ORG_ID
SHARED_SERVICES_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $SHARED_SERVICES_FOLDER | awk '{print $3}'`

gcloud alpha resource-manager folders create \
--display-name=$CLIENT_1_FOLDER \
--organization=$ORG_ID
CLIENT_1_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_1_PROJECT | awk '{print $3}'`

gcloud alpha resource-manager folders create \
--display-name=$CLIENT_2_FOLDER \
--organization=$ORG_ID
CLIENT_2_FOLDER_ID=`gcloud alpha resource-manager folders list --organization=$ORG_ID | grep $CLIENT_2_PROJECT | awk '{print $3}'`

# Create Projects
# https://cloud.google.com/sdk/gcloud/reference/projects/create
gcloud projects create $HUB_PROJECT \
--folder=$SHARED_SERVICES_FOLDER_ID
gcloud beta billing projects link $HUB_PROJECT --billing-account=$BILLING_ID
HUB_PROJECT_ID=`gcloud projects list | grep $HUB_PROJECT | awk '{print $3}'`

gcloud projects create $CLIENT_1_PROJECT \
--folder=$CLIENT_1_FOLDER_ID
gcloud beta billing projects link $CLIENT_1_PROJECT --billing-account=$BILLING_ID
CLIENT_1_PROJECT_ID=`gcloud projects list | grep $CLIENT_1_PROJECT | awk '{print $3}'`

gcloud projects create $CLIENT_2_PROJECT \
--folder=$CLIENT_2_FOLDER_ID
gcloud beta billing projects link $CLIENT_2_PROJECT --billing-account=$BILLING_ID
CLIENT_2_PROJECT_ID=`gcloud projects list | grep $CLIENT_2_PROJECT | awk '{print $3}'`

# Assign Project Owner roles in order to enable ease of use for evaluation
# https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding
gcloud projects add-iam-policy-binding $HUB_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT_ID \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT_ID \
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

gcloud config set project $CLIENT_1_PROJECT
gcloud services enable \
bigquery.googleapis.com \
compute.googleapis.com \
pubsub.googleapis.com \
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

gcloud config set project $CLIENT_2_PROJECT
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
--bgp-routing-mode=global

gcloud compute networks subnets create $HUB_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$HUB_PROJECT_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$USE_REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create $CLIENT_1_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$CLIENT_1_PROJECT_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$USE_REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create $CLIENT_2_PROJECT_SUBNET \
--project=$HUB_PROJECT \
--range=$CLIENT_2_PROJECT_SUBNET_RANGE \
--network=$HUB_PROJECT_VPC \
--region=$EUW_REGION \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute shared-vpc enable $HUB_PROJECT_ID
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_1_PROJECT
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_2_PROJECT

# Create Google Kubernetes Engine instance for Hub Project
# https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
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
--node-labels env=prod \
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

# Create Google Cloud Storage buckets for Client Project
# https://cloud.google.com/storage/docs/creating-buckets#storage-create-bucket-gsutil
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_RAW_SB
gsutil versioning set on gs://$CLIENT_1_RAW_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_TRUSTED_SB
gsutil versioning set on gs://$CLIENT_1_TRUSTED_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_ACTIVATED_SB
gsutil versioning set on gs://$CLIENT_1_ACTIVATED_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_QUBOLE_SB
gsutil versioning set on gs://$CLIENT_1_QUBOLE_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_1_EXTRACTION_SB

gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_RAW_SB_2
gsutil versioning set on gs://$CLIENT_2_RAW_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_TRUSTED_SB_2
gsutil versioning set on gs://$CLIENT_2_TRUSTED_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_ACTIVATED_SB_2
gsutil versioning set on gs://$CLIENT_2_ACTIVATED_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_QUBOLE_SB_2
gsutil versioning set on gs://$CLIENT_2_QUBOLE_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_2_EXTRACTION_SB

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

# Create Bastion Hosts and TCP load balancer for Client Projects
# https://cloud.google.com/sdk/gcloud/reference/compute/instance-groups/managed
gcloud config set project $CLIENT_1_PROJECT
gcloud iam service-accounts create $CLIENT_1_BASTION_SA --display-name "Bastion Service Account"
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_FULL \
--role=roles/owner

gcloud compute addresses create $CLIENT_1_BASTION_IP \
--global \
--ip-version=IPV4
CLIENT_1_BASTION_IP_ADDRESS=`gcloud compute addresses list | grep $CLIENT_1_BASTION_IP | awk '{print $2}'`

gcloud compute --project=$CLIENT_1_PROJECT instances create $CLIENT_1_BASTION \
--zone=$USE_ZONE \
--machine-type=n2-standard-2 \
--subnet=$CLIENT_1_PROJECT_SUBNET \
--address=$CLIENT_1_BASTION_IP_ADDRESS \
--network-tier=PREMIUM \
--maintenance-policy=MIGRATE \
--service-account=$CLIENT_1_BASTION_SA_FULL \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--tags=bastion \
--image=centos-7-v20200714 \
--image-project=centos-cloud \
--boot-disk-size=20GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=instance-1 \
--shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any

gcloud compute --project=$CLIENT_1_PROJECT firewall-rules create "bastion-ingress-22" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=34.73.1.130/32 \
--target-tags=bastion

gcloud compute --project=$CLIENT_1_PROJECT firewall-rules create "bastion-VPC-ingress-7000" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:7000 \
--source-ranges=$CLIENT_1_PROJECT_SUBNET_RANGE \
--target-tags=bastion

gcloud config set project $CLIENT_2_PROJECT
gcloud iam service-accounts create $CLIENT_2_BASTION_SA --display-name "Bastion Service Account"
gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_FULL \
--role=roles/owner

gcloud compute addresses create $CLIENT_2_BASTION_IP \
--global \
--ip-version=IPV4
CLIENT_2_BASTION_IP_ADDRESS=`gcloud compute addresses list | grep $CLIENT_2_BASTION_IP | awk '{print $2}'`

gcloud compute --project=$CLIENT_2_PROJECT instances create $CLIENT_2_BASTION \
--zone=$EUW_REGION \
--machine-type=n2-standard-2 \
--subnet=$CLIENT_2_PROJECT_SUBNET \
--address=$CLIENT_2_BASTION_IP_ADDRESS \
--network-tier=PREMIUM \
--maintenance-policy=MIGRATE \
--service-account=$CLIENT_2_BASTION_SA_FULL \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--tags=bastion \
--image=centos-7-v20200714 \
--image-project=centos-cloud \
--boot-disk-size=20GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=instance-1 \
--shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any

gcloud compute --project=$CLIENT_2_PROJECT firewall-rules create "bastion-ingress-22" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=34.73.1.130/32 \
--target-tags=bastion

gcloud compute --project=$CLIENT_2_PROJECT firewall-rules create "bastion-VPC-ingress-7000" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:7000 \
--source-ranges=$CLIENT_2_PROJECT_SUBNET_RANGE \
--target-tags=bastion

##### https://stackoverflow.com/questions/58138006/how-to-reuse-static-ip-address-on-google-cloud-compute-engine-from-command-line

gcloud compute instance-templates create $CLIENT_1_INSTANCE_TEMPLATE \
--machine-type=n2-standard-2 \
--subnet=projects/$HUB_PROJECT/regions/$REGION/subnetworks/$CLIENT_1_PROJECT_SUBNET \
--no-address \
--maintenance-policy=MIGRATE \
--service-account=$CLIENT_1_COMPUTE_SA \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--region=$USC_REGION \
--tags=gcp-bastion \
--image=centos-7-v20200714 \
--image-project=centos-cloud \
--boot-disk-size=20GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=$CLIENT_1_INSTANCE_TEMPLATE \
--shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any


gcloud compute health-checks create tcp $CLIENT_1_MIG_HEALTHCHECK \
--global \
--timeout "5" \
--check-interval "10" \
--unhealthy-threshold "3" \
--healthy-threshold "2" \
--port "80"

gcloud compute instance-groups managed create $CLIENT_1_INSTANCE_GROUP \
--template=$CLIENT_1_INSTANCE_TEMPLATE \
--zones=us-central1-b,us-central1-c \
--size=1 \
--instance-redistribution-type=PROACTIVE \
--health-check=$CLIENT_1_MIG_HEALTHCHECK \
--initial-delay=300

gcloud compute instance-groups managed set-autoscaling $CLIENT_1_INSTANCE_GROUP \
--region=$REGION \
--cool-down-period "60" \
--max-num-replicas "1" \
--min-num-replicas "1" \
--target-cpu-utilization "0.9" \
--mode "on"

gcloud compute health-checks create tcp $CLIENT_1_LB_HEALTHCHECK \
--global \
--timeout "5" \
--check-interval "10" \
--unhealthy-threshold "3" \
--healthy-threshold "2" \
--port "80"

gcloud compute backend-services create $CLIENT_1_BACKEND \
--protocol TCP \
--global \
--health-checks $CLIENT_1_LB_HEALTHCHECK

gcloud compute backend-services add-backend $CLIENT_1_BACKEND \
--global \
--instance-group $CLIENT_1_INSTANCE_GROUP \
--instance-group-region=$REGION \
--balancing-mode UTILIZATION \
--max-utilization 0.8

gcloud compute addresses create $CLIENT_1_BASTION_IP \
--global \
--ip-version=IPV4

gcloud compute forwarding-rules create $CLIENT_1_FORWARD_RULE_1 \
--global \
--address=$CLIENT_1_BASTION_IP \
--ports=22





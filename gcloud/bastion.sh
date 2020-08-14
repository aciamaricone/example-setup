# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
USE_REGION=$4
EUW_REGION=$5
USE_ZONE=$6
EUW_ZONE=$7
QUBOLE_PUBLIC_KEY=${14}
QUBOLE_SERVICE_ACCOUNT=${15}
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
HUB_PROJECT_SUBNET_RANGE=10.1.0.0/21
CLIENT_1_GCE_SUBNET=projects/$HUB_PROJECT/regions/$USE_REGION/subnetworks/$CLIENT_1_PROJECT-central-subnet
CLIENT_1_PROJECT_SUBNET_RANGE=10.2.8.0/21
CLIENT_2_GCE_SUBNET=projects/$HUB_PROJECT/regions/$EUW_REGION/subnetworks/$CLIENT_2_PROJECT-central-subnet
CLIENT_2_PROJECT_SUBNET_RANGE=10.2.16.0/21
CLIENT_1_BASTION_IP="$CLIENT_1_PROJECT"-bastion-ip
CLIENT_2_BASTION_IP="$CLIENT_2_PROJECT"-bastion-ip
CLIENT_1_BASTION="$CLIENT_1_PROJECT"-bastion
CLIENT_2_BASTION="$CLIENT_2_PROJECT"-bastion
CLIENT_1_BASTION_SA=bastion-sa
CLIENT_1_BASTION_SA_QCOMPUTE=bastion-sa-qubole-compute
CLIENT_1_BASTION_SA_QINSTANCE=bastion-sa-qubole-instance
CLIENT_2_BASTION_SA=bastion-sa
CLIENT_2_BASTION_SA_QCOMPUTE=bastion-sa-qubole-compute
CLIENT_2_BASTION_SA_QINSTANCE=bastion-sa-qubole-instance
CLIENT_1_BASTION_SA_FULL="$CLIENT_1_BASTION_SA@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
CLIENT_1_BASTION_SA_QCOMPUTE_FULL="$CLIENT_1_BASTION_SA_QCOMPUTE@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
CLIENT_1_BASTION_SA_QINSTANCE_FULL="$CLIENT_1_BASTION_SA_QINSTANCE@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
CLIENT_2_BASTION_SA_FULL="$CLIENT_2_BASTION_SA@$CLIENT_2_PROJECT.iam.gserviceaccount.com"
CLIENT_2_BASTION_SA_QCOMPUTE_FULL="$CLIENT_2_BASTION_SA_QCOMPUTE@$CLIENT_2_PROJECT.iam.gserviceaccount.com"
CLIENT_2_BASTION_SA_QINSTANCE_FULL="$CLIENT_2_BASTION_SA_QINSTANCE@$CLIENT_2_PROJECT.iam.gserviceaccount.com"
CLIENT_1_RAW_SB="$CLIENT_1_PROJECT"-raw
CLIENT_1_TRUSTED_SB="$CLIENT_1_PROJECT"-trusted
CLIENT_1_ACTIVATED_SB="$CLIENT_1_PROJECT"-activated
CLIENT_1_EXTRACTION_SB="$CLIENT_1_PROJECT"-extraction
CLIENT_1_QUBOLE_SB="$CLIENT_1_PROJECT"-qdsdefault
CLIENT_1_ACX_SB="$CLIENT_1_PROJECT"-acx
CLIENT_2_RAW_SB="$CLIENT_2_PROJECT"-raw
CLIENT_2_TRUSTED_SB="$CLIENT_2_PROJECT"-trusted
CLIENT_2_ACTIVATED_SB="$CLIENT_2_PROJECT"-activated
CLIENT_2_EXTRACTION_SB="$CLIENT_2_PROJECT"-extraction
CLIENT_2_QUBOLE_SB="$CLIENT_2_PROJECT"-qdsdefault
CLIENT_2_ACX_SB="$CLIENT_2_PROJECT"-acx

# Create Qubole required service accounts and provide appropriate IAM access
gcloud config set project $CLIENT_1_PROJECT
gcloud iam service-accounts create $CLIENT_1_BASTION_SA --display-name "$CLIENT_1_PROJECT Bastion Service Account"
gcloud iam service-accounts create $CLIENT_1_BASTION_SA_QCOMPUTE --display-name "$CLIENT_1_PROJECT Bastion Compute Service Account"
gcloud iam service-accounts create $CLIENT_1_BASTION_SA_QINSTANCE --display-name "$CLIENT_1_PROJECT Bastion Instance Service Account"

gcloud config set project $CLIENT_2_PROJECT
gcloud iam service-accounts create $CLIENT_2_BASTION_SA --display-name "$CLIENT_2_PROJECT Bastion Service Account"
gcloud iam service-accounts create $CLIENT_2_BASTION_SA_QCOMPUTE --display-name "$CLIENT_2_PROJECT Bastion Compute Service Account"
gcloud iam service-accounts create $CLIENT_2_BASTION_SA_QINSTANCE --display-name "$CLIENT_2_PROJECT Bastion Instance Service Account"
gcloud iam service-accounts create testserviceaccount --display-name "$CLIENT_2_PROJECT Bastion Instance Service Account"

gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_FULL \
--role=roles/owner
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--role=roles/compute.securityAdmin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--role=roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--role=roles/bigquery.dataViewer
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--role=roles/compute.securityAdmin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--role=roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--role=roles/bigquery.readSessionUser

gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_FULL \
--role=roles/owner
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--role=roles/compute.securityAdmin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--role=roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--role=roles/bigquery.dataViewer
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--role=roles/compute.securityAdmin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--role=roles/compute.instanceAdmin.v1
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--role=roles/storage.admin
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--role=roles/bigquery.readSessionUser

gcloud config set project $CLIENT_1_PROJECT
gcloud iam service-accounts add-iam-policy-binding $CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--member=serviceAccount:$QUBOLE_SERVICE_ACCOUNT \
--role=roles/iam.serviceAccountUser
gcloud iam service-accounts add-iam-policy-binding $CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--member=serviceAccount:$QUBOLE_SERVICE_ACCOUNT \
--role=roles/iam.serviceAccountTokenCreator
gcloud iam service-accounts add-iam-policy-binding $CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL \
--role=roles/iam.serviceAccountUser
gcloud iam service-accounts add-iam-policy-binding $CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--member=serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL \
--role=roles/iam.serviceAccountUser

gcloud config set project $CLIENT_2_PROJECT
gcloud iam service-accounts add-iam-policy-binding $CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--member=serviceAccount:$QUBOLE_SERVICE_ACCOUNT \
--role=roles/iam.serviceAccountUser
gcloud iam service-accounts add-iam-policy-binding $CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--member=serviceAccount:$QUBOLE_SERVICE_ACCOUNT \
--role=roles/iam.serviceAccountTokenCreator
gcloud iam service-accounts add-iam-policy-binding $CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL \
--role=roles/iam.serviceAccountUser
gcloud iam service-accounts add-iam-policy-binding $CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--member=serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL \
--role=roles/iam.serviceAccountUser

gsutil iam ch serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL:admin gs://$CLIENT_1_QUBOLE_SB
gsutil iam ch serviceAccount:$CLIENT_1_BASTION_SA_QCOMPUTE_FULL:admin gs://$CLIENT_1_ACX_SB
gsutil iam ch serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL:admin gs://$CLIENT_1_QUBOLE_SB
gsutil iam ch serviceAccount:$CLIENT_1_BASTION_SA_QINSTANCE_FULL:admin gs://$CLIENT_1_ACX_SB

gsutil iam ch serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL:admin gs://$CLIENT_2_QUBOLE_SB
gsutil iam ch serviceAccount:$CLIENT_2_BASTION_SA_QCOMPUTE_FULL:admin gs://$CLIENT_2_ACX_SB
gsutil iam ch serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL:admin gs://$CLIENT_2_QUBOLE_SB
gsutil iam ch serviceAccount:$CLIENT_2_BASTION_SA_QINSTANCE_FULL:admin gs://$CLIENT_2_ACX_SB

# Establish Bastion Host per Client Projects and appropriate SSH access
gcloud config set project $CLIENT_1_PROJECT
gcloud compute addresses create $CLIENT_1_BASTION_IP \
--region=$USE_REGION
CLIENT_1_BASTION_IP_ADDRESS=`gcloud compute addresses list | grep $CLIENT_1_BASTION_IP | awk '{print $2}'`
gcloud compute addresses create $CLIENT_2_BASTION_IP \
--region=$EUW_REGION
CLIENT_2_BASTION_IP_ADDRESS=`gcloud compute addresses list | grep $CLIENT_2_BASTION_IP | awk '{print $2}'`

gcloud compute --project=$CLIENT_1_PROJECT instances create $CLIENT_1_BASTION \
--zone=$USE_ZONE \
--machine-type=n1-standard-2 \
--subnet=$CLIENT_1_GCE_SUBNET \
--address="$CLIENT_1_BASTION_IP_ADDRESS" \
--network-tier=PREMIUM \
--metadata=enable-oslogin=TRUE \
--metadata-from-file startup-script=/home/$USER/bastion-startup-script.sh \
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

gcloud compute --project=$CLIENT_2_PROJECT instances create $CLIENT_2_BASTION \
--zone=$EUW_ZONE \
--machine-type=n1-standard-2 \
--subnet=$CLIENT_2_GCE_SUBNET \
--address=$CLIENT_2_BASTION_IP_ADDRESS \
--network-tier=PREMIUM \
--metadata=enable-oslogin=TRUE \
--metadata-from-file startup-script=/home/$USER/bastion-startup-script.sh \
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

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-tcp-iap" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=35.235.240.0/20 \
--target-tags=bastion \
--enable-logging
gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-qubole" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=34.73.1.130/32 \
--target-tags=bastion \
--enable-logging
gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-7000-qubole" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:7000 \
--source-ranges=$CLIENT_1_PROJECT_SUBNET_RANGE \
--target-tags=bastion \
--enable-logging
gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc1" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=139.61.117.0/24 \
--target-tags=bastion \
--enable-logging
gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc2" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=198.160.103.0/24 \
--target-tags=bastion \
--enable-logging
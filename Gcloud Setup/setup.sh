# Variables
HUB_PROJECT=udl-control-hub-phase1
CLIENT_1_PROJECT=udl-core-sandbox-1
CLIENT_2_PROJECT=udl-core-sandbox-2
USER1=aciamaricone@google.com
USE_REGION=us-east1
EUW_REGION=europe-west1
USE_ZONE=us-east1-b
EUW_ZONE=europe-west1-b






QUBOLE_CLIENT_1_SA="$CLIENT_1_PROJECT"-qubole-sa
QUBOLE_CLIENT_1_SA_FULL="$QUBOLE_CLIENT_1_SA@$CLIENT_1_PROJECT.iam.gserviceaccount.com"
QUBOLE_CLIENT_2_SA="$CLIENT_2_PROJECT"-qubole-sa
QUBOLE_CLIENT_2_SA_FULL="$QUBOLE_CLIENT_2_SA@$CLIENT_1_PROJECT.iam.gserviceaccount.com"











gcloud projects add-iam-policy-binding service-network-275814 \
--member=user:aciamaricone@google.com \
--role=roles/storage.objectViewer \
--condition=expression=[resource.name.startsWith`projects/service-network-275814/buckets/3456789132412841928479/objects/Screen`],title=[testingcondition]


gsutil -m iam set 

gcloud projects add-iam-policy-binding example-project-id-1 
--member='user:test-user@gmail.com' --role='roles/browser' 
--condition='expression=request.time <
   timestamp("2019-01-01T00:00:00Z"),title=expires_end_of_2018,descrip  tion=Expires at midnight on 2018-12-31'











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

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=34.73.1.130/32 \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-vpc-ingress-7000" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:7000 \
--source-ranges=$CLIENT_1_PROJECT_SUBNET_RANGE \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc1" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=139.61.117.0/24 \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc2" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=198.160.103.0/24 \
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
--zone=$EUW_ZONE \
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

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-qubole" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=34.73.1.130/32 \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-vpc-ingress-7000" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:7000 \
--source-ranges=$CLIENT_2_PROJECT_SUBNET_RANGE \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc1" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=139.61.117.0/24 \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-apc2" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=198.160.103.0/24 \
--target-tags=bastion

gcloud compute --project=$HUB_PROJECT firewall-rules create "bastion-ingress-22-iap" \
--direction=INGRESS \
--priority=1000 \
--network=$HUB_PROJECT_VPC \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=35.235.240.0/20 \
--target-tags=bastion





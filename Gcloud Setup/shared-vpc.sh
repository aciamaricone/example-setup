# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
USE_REGION=us-east1
EUW_REGION=europe-west1
HUB_PROJECT_VPC="$HUB_PROJECT"-vpc
HUB_PROJECT_SUBNET="$HUB_PROJECT"-central-subnet
HUB_PROJECT_SUBNET_RANGE=10.1.0.0/21
CLIENT_1_PROJECT_SUBNET="$CLIENT_1_PROJECT"-central-subnet
CLIENT_1_PROJECT_SUBNET_RANGE=10.2.8.0/21
CLIENT_2_PROJECT_SUBNET="$CLIENT_2_PROJECT"-central-subnet
CLIENT_2_PROJECT_SUBNET_RANGE=10.2.16.0/21

# Create Shared VPC network for Projects
# https://cloud.google.com/vpc/docs/provisioning-shared-vpc#gcloud_1
gcloud config set project $HUB_PROJECT
y | gcloud compute firewall-rules delete default-allow-icmp
y | gcloud compute firewall-rules delete default-allow-internal
y | gcloud compute firewall-rules delete default-allow-rdp
y | gcloud compute firewall-rules delete default-allow-ssh
y | gcloud compute networks delete default

gcloud config set project $CLIENT_1_PROJECT
y | gcloud compute firewall-rules delete default-allow-icmp
y | gcloud compute firewall-rules delete default-allow-internal
y | gcloud compute firewall-rules delete default-allow-rdp
y | gcloud compute firewall-rules delete default-allow-ssh
y | gcloud compute networks delete default

gcloud config set project $CLIENT_2_PROJECT
y | gcloud compute firewall-rules delete default-allow-icmp
y | gcloud compute firewall-rules delete default-allow-internal
y | gcloud compute firewall-rules delete default-allow-rdp
y | gcloud compute firewall-rules delete default-allow-ssh
y | gcloud compute networks delete default

gcloud config set project $HUB_PROJECT
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

gcloud compute shared-vpc enable $HUB_PROJECT
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_1_PROJECT
gcloud compute shared-vpc associated-projects add --host-project=$HUB_PROJECT $CLIENT_2_PROJECT
# Parameters
CLIENT_PROJECT=$1

# Enable appropriate product APIs
gcloud config set project $CLIENT_PROJECT
gcloud services enable \
bigquery.googleapis.com \
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
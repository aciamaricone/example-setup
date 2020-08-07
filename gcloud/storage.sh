# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
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

# Create Google Cloud Storage buckets for Client Projects
gcloud config set project $CLIENT_1_PROJECT
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_RAW_SB
gsutil versioning set on gs://$CLIENT_1_RAW_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_TRUSTED_SB
gsutil versioning set on gs://$CLIENT_1_TRUSTED_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_ACTIVATED_SB
gsutil versioning set on gs://$CLIENT_1_ACTIVATED_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_1_EXTRACTION_SB
gsutil mb -l us-central1 -b on -p $CLIENT_1_PROJECT gs://$CLIENT_1_QUBOLE_SB
gsutil versioning set on gs://$CLIENT_1_QUBOLE_SB

gcloud config set project $CLIENT_2_PROJECT
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_RAW_SB_2
gsutil versioning set on gs://$CLIENT_2_RAW_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_TRUSTED_SB_2
gsutil versioning set on gs://$CLIENT_2_TRUSTED_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_ACTIVATED_SB_2
gsutil versioning set on gs://$CLIENT_2_ACTIVATED_SB_2
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_2_EXTRACTION_SB
gsutil mb -l us-central1 -b on -p $CLIENT_2_PROJECT gs://$CLIENT_2_QUBOLE_SB_2
gsutil versioning set on gs://$CLIENT_2_QUBOLE_SB_2
# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
USE_REGION=$4
EUW_REGION=$5
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

# Create Google Cloud Storage buckets for Client Projects
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_RAW_SB
gsutil versioning set on gs://$CLIENT_1_RAW_SB
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_TRUSTED_SB
gsutil versioning set on gs://$CLIENT_1_TRUSTED_SB
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_ACTIVATED_SB
gsutil versioning set on gs://$CLIENT_1_ACTIVATED_SB
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_1_EXTRACTION_SB
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_QUBOLE_SB
gsutil versioning set on gs://$CLIENT_1_QUBOLE_SB
gsutil mb -b on -l $USE_REGION -p $CLIENT_1_PROJECT gs://$CLIENT_1_ACX_SB
gsutil versioning set on gs://$CLIENT_1_ACX_SB

gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_RAW_SB_2
gsutil versioning set on gs://$CLIENT_2_RAW_SB_2
gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_TRUSTED_SB_2
gsutil versioning set on gs://$CLIENT_2_TRUSTED_SB_2
gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_ACTIVATED_SB_2
gsutil versioning set on gs://$CLIENT_2_ACTIVATED_SB_2
gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_EXTRACTION_SB
gsutil versioning set on gs://$CLIENT_2_EXTRACTION_SB
gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_QUBOLE_SB_2
gsutil versioning set on gs://$CLIENT_2_QUBOLE_SB_2
gsutil mb -b on -l $EUW_REGION -p $CLIENT_2_PROJECT gs://$CLIENT_2_ACX_SB
gsutil versioning set on gs://$CLIENT_2_ACX_SB
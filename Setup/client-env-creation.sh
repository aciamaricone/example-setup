# Parameters
CLIENT_PROJECT=$1

# Enable appropriate product APIs
gcloud config set project $CLIENT_PROJECT
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

# Create custom network

# Create Qubole

# Create Google Cloud Storage buckets
RAW_SB="$CLIENT_PROJECT"_raw
TRUSTED_SB="$CLIENT_PROJECT"_trusted
ACTIVATED_SB="$CLIENT_PROJECT"_activated
gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$RAW_SB
gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$TRUSTED_SB
gsutil mb -l us-central1 -b on -p $CLIENT_PROJECT gs://$ACTIVATED_SB
gsutil versioning set on gs://$MODELS_SB
gsutil versioning set on gs://$MODELS_SB
gsutil versioning set on gs://$MODELS_SB
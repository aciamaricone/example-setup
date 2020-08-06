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

gcloud projects add-iam-policy-binding service-network-275814 \
--member=user:aciamaricone@google.com \
--role=roles/storage.objectViewer \
--condition=expression=[resource.name.startsWith`projects/service-network-275814/buckets/3456789132412841928479/objects/Screen`],title=[testingcondition]


gsutil -m iam set 

gcloud projects add-iam-policy-binding example-project-id-1 
--member='user:test-user@gmail.com' --role='roles/browser' 
--condition='expression=request.time <
   timestamp("2019-01-01T00:00:00Z"),title=expires_end_of_2018,descrip  tion=Expires at midnight on 2018-12-31'
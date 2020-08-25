# Variables
HUB_PROJECT=$1
CLIENT_1_PROJECT=$2
CLIENT_2_PROJECT=$3
USER1=${12}
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

# Assign Project Owner roles in order to enable ease of use for evaluation
gcloud projects add-iam-policy-binding $HUB_PROJECT \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member=user:$USER1 \
--role=roles/owner

gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member=user:$USER1 \
--role=roles/owner

# Assign conditional IAM policies to GCS objects
gcloud projects add-iam-policy-binding $CLIENT_1_PROJECT \
--member user:$USER1 \
--role=roles/storage.objectViewer \
--condition title=raw_objects,expression="resource.name.startsWith('projects/$CLIENT_1_PROJECT/buckets/$CLIENT_1_RAW_SB/objects/raw_object')"

gcloud projects add-iam-policy-binding $CLIENT_2_PROJECT \
--member user:$USER1 \
--role=roles/storage.objectViewer \
--condition title=raw_objects,expression="resource.name.startsWith('projects/$CLIENT_2_PROJECT/buckets/$CLIENT_2_RAW_SB/objects/raw_object')"
# Parameters
HUB_PROJECT=$1

# Enable appropriate product APIs
gcloud config set project $HUB_PROJECT
storage-api.googleapis.com \
storage-component.googleapis.com \
storagetransfer.googleapis.com 

# Create custom VPC network

# Create Google Kubernetes Engine instance

# Create Google Container Registry
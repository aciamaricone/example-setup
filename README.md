# UDL-POC
You have the option to use gcloud commands or Terraform commands in an existing project (assuming existing organization admin role). Both should be run in the Cloud Shell due to existing SDK and CLI tools.

# TO DO
GCLOUD
Qubole deployment scripts
Create firewall rules for each VPC 

TERRAFORM
Create Terraform scripts

## Gcloud Setup
In gcloud setup, two folders (one shared services, one client specific) will be created. These folders will then hold one project each (hub project, client specific project). A specified user will be granted project owner role on both projects. Within the hub project, a VPC and GKE cluster (with a BigQuery dataset for usage metering) will be created while in the client project, several GCS buckets and a Qubole deployment will be created.

## Terraform Setup 
In the Terraform setup, the same actions as the gcloud setup will be completed, in addition to the creation of a Terraform admin project. This will enable the creation of the above steps, through an authenticated service account, and future environment creation.
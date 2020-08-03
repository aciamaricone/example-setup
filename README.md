# UDL-POC

## TO DO
Call IP gcloud to get ip addres for static IP
Need the startup script for the bastion host (for assignment of the static IP)
https://aws.amazon.com/quickstart/architecture/linux-bastion/
https://docs.aws.amazon.com/quickstart/latest/linux-bastion/welcome.html 

Need to assign IAM role by GCS tag - IAM conditions

## FUTURE IMPROVEMENTS
Separate projects for anonymous and known data
Separate project for GCR, aggregated logging
IAP for SSH access
HA bastion host

### Setup Steps
1) Create two folders: one shared services, one client
2) Create three projects: one hub, two client
3) Create individual VPCs for each project
4) In hub project, create a Shared VPC, a GKE cluster, and a BigQuery dataset
5) In client projects, create storage buckets
6) Create Qubole Master Account via GCP marketplace
7) Create necessary VPC firewall rules

### Setup Script
In order to create the necessary POC environments, you can either execute the total script for complete creation or individual scripts.
```
Folder creation -> Project creation -> IAM creation -> Hub environment creation -> Client environment creation
```
This script will create all tasks detailed below in individual scripts
```
./setup.sh $(cat setup-arguments.txt)
```
Update setup-arguments.txt with appropriate arguments
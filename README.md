# UDL-POC

## Setup Steps
1) Create two folders: one shared services, one client
2) Create three projects: one hub, two client
3) Create individual VPCs for each project
4) In hub project, create a Shared VPC, a GKE cluster, and a BigQuery dataset
5) In client projects, create storage buckets
6) Create Qubole Master Account via GCP marketplace
7) Create necessary VPC firewall rules

## Setup Script
In order to create the necessary POC environments, you can either execute the total script for complete creation or individual scripts.
```
Folder creation -> Project creation -> IAM creation -> Hub environment creation -> Client environment creation
```

### Setup Script
This script will create all tasks detailed below in individual scripts
```
./setup.sh $(cat setup-arguments.txt)
```
Update setup-arguments.txt with appropriate arguments
# UDL-POC

## TO DO
VPN and Qubole ssh keys
- Create startup scripts
https://cloud.google.com/compute/docs/startupscript
https://docs-gcp.qubole.com/en/latest/admin-guide/cluster-admin/private-subnet-gcp.html

Include IAM conditions

Continuous deployment for GKE from GCR
- SA creation for multiple project access
https://cloud.google.com/container-registry/docs/access-control

## FUTURE IMPROVEMENTS
Separate projects for anonymous and known data
Separate project for GCR, aggregated logging
HA bastion hosts per client project
Robust Terraform scripts utilizing specific GCP modules

### Setup Steps
1) Create two folders: one shared services, one client
2) Create three projects: one hub, two client
3) Create individual VPCs for each project
4) In hub project, create a Shared VPC, a GKE cluster, and a BigQuery dataset
5) In client projects, create storage buckets
6) Create Qubole Master Account via GCP marketplace
7) Create necessary VPC firewall rules

### Setup Script
To create an entirely new customer, execute scripts as follows:
```
Folders -> Projects -> IAM  -> API -> Shared-VPC -> Storage -> GKE -> GCR -> Bastion -> Qubole
```
Update or expand arguments.txt with the appropriate arguments (prebuilt currently so unnecessary unless changing approach)
```
./SCRIPT_NAME.sh $(cat arguments.txt)
```
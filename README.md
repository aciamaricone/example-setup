# UDL-POC

# TO DO
Manually deploy Qubole (can automate with Terraform in the future however, in order to ensure free deployment, manual marketplace selection is optimal for POC)
Create firewall rules for each VPC

## Setup Steps
1) Create two projects: one hub, one client
2) Create individual VPCs for each project
3) In hub project, create GKE cluster and container registry
4) In client project, create storage buckets

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

## Individual Scripts

### Folder Creation Script
This script will create the folders, underneath an existing organization node, for project organization
```
./folder-creation.sh <domain> <shared services folder name> <client folder name>
```
Domain - Supply the complete domain (example: google.com)
Shared Services Folder Name - Supply a name for a folder to hold all shared services projects (keep in mind you can only use letters, numbers, single quotes, hyphens, spaces, underscores)
Client Folder Name - Supply a name for a folder that will hold all Client projects related to their UDL environments (keep in mind you can only use letters, numbers, single quotes, hyphens, spaces, underscores)

### Project Creation Script
This script will create projects within the newly created folders
```
./project-creation.sh <shared services folder name> <client folder name> <hub project name> <client project name> <billing account ID>
```
Shared Services Folder Name - Utilize recently created Folder name, which will automatically capture the Folder ID
Client Folder Name - Utilize recently created Folder name, which will automatically capture the Folder ID
Hub Project Name - Supply a name for UDL hub project (keep in mind you must start with a letter and can only use lowercase letters, numbers, single quotes, hyphens, spaces or exclamation points)
Client Project Name - Supply a name for the client UDL project (keep in mind you must start with a letter and can only use lowercase letters, numbers, single quotes, hyphens, spaces or exclamation points)
Billing Account ID - Provide billing account ID to assign to new projects (example: 01AFB2-4DK3DJ-141029)

### IAM Creation Script
This script will provision broad IAM privileges to POC user in both projects
```
./iam-creation.sh <user email address> <hub project name> <client project name>
```
User Email Address - Supply an email address, within company domain, for appropriate IAM role allocation
Hub Project Name - Utilize recently created Hub Project name
Client Project Name - Utilize recently created Client Project name

### Hub Environment Creation Script
This script will enable the appropriate product APIs and create a custom VPC, a Google Kubernetes Engine cluster, and a BigQuery dataset for GKE usage metrics
```
./hub-env-creation.sh <hub project name>
```
Hub Project Name - Utilize recently created Hub Project name

### Client Environment Creation Script
This script will enable the appropriate product APIs and create a custom VPC along with the necessary Cloud Storage buckets.
```
./client-env-creation.sh <client project name>
```
Client Project Name - Utilize recently created Client Project name
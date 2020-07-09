# UDL-POC

## Setup Steps
1) Create two projects: one hub, one client
2) Create individual VPCs for each project
3) In hub project, create GKE cluster and container registry
4) In client project, create Qubole connection and storage buckets

## Setup Scripts
In order to create the necessary POC environments, you can either execute the total script for complete creation or individual scripts.
```
Folder creation -> Project creation -> IAM creation ->
```

### Setup Script
```

```


### Folder Creation Script
```
./folder-creation.sh <domain> <shared services folder name> <client folder name>
```
Domain - Supply the complete domain (example: google.com)
Shared Services Folder Name - Supply a name for a folder to hold all shared services projects (keep in mind you can only use letters, numbers, single quotes, hyphens, spaces, underscores)
Client Folder Name - Supply a name for a folder that will hold all Client projects related to their UDL environments (keep in mind you can only use letters, numbers, single quotes, hyphens, spaces, underscores)

### Project Creation Script
```
./project-creation.sh <shared services folder name> <client folder name> <hub project name> <client project name> <billing account ID>
```
Shared Services Folder Name - Utilize recently created Folder name, which will automatically capture the Folder ID
Client Folder Name - Utilize recently created Folder name, which will automatically capture the Folder ID
Hub Project Name - Supply a name for UDL hub project (keep in mind you must start with a letter and can only use lowercase letters, numbers, single quotes, hyphens, spaces or exclamation points)
Client Project Name - Supply a name for the client UDL project (keep in mind you must start with a letter and can only use lowercase letters, numbers, single quotes, hyphens, spaces or exclamation points)
Billing Account ID - Provide billing account ID to assign to new projects (example: 01AFB2-4DK3DJ-141029)
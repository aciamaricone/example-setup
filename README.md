# UDL-POC

## FUTURE IMPROVEMENTS
Separate project for GCR, aggregated logging, Terraform
HA bastion hosts per client project

### Setup Script
To create an entirely new customer, execute scripts as follows:
```
Folders -> Projects -> API -> Shared-VPC -> Storage -> GKE -> GCR -> Bastion -> USER-IAM -> Qubole
```
Update or expand arguments.txt with the appropriate arguments (prebuilt currently so unnecessary unless changing approach)
```
./SCRIPT_NAME.sh $(cat arguments.txt)
```
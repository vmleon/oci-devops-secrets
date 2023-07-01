# OCI DevOps Secrets

This repository is a minimal complete verifiable issue report.

OCI DevOps fails when reading secrets with special character content.

It uses Terraform to deploy Vault, Master key and secret. DevOps Project and Deployment Pipeline with a `command_spec.yaml` reading the secret content from the secret OCID.

This issue is important because the secret could be a User Auth Token, OCI generated with special characters.

## Run minimal complete verifiable report

> This has been tested on OCI Cloud Shell.

Copy `terraform.tfvars` template.

```bash
cp terraform/terraform.tfvars.template terraform/terraform.tfvars
```

Edit `terraform.tfvars` to fit your environment.

```bash
vim terraform/terraform.tfvars
```

Run terraform `init`.

```bash
terraform init
```

Run terraform `apply`.

```bash
terraform apply -auto-approve
```


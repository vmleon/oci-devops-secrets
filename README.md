# OCI DevOps Secrets

## Overview

This repository is a minimal complete verifiable issue report.

OCI DevOps fails when reading OCI Vault secrets with special character content.

This report uses Terraform to deploy **Vault**, **Master key** and two **Secrets**. It also deploys **DevOps Project** and **Deployment Pipeline** with a `command_spec.yaml` that read the secret content from the secret OCID.

```yaml
env:
  vaultVariables:
    GOOD_SECRET: ${good_secret_id}
    BAD_SECRET: ${bad_secret_id}
```

- Default Good Secret content: `abcde123`
- Default Bad Secret content: `qwe<rt(y=123`

The content can be changed with a terraform variable in `terraform.tfvars`:
- `good_secret_content = "anothervalue"`
- `bad_secret_content  = "anothervalue"`

This issue is important because the secret could be an **OCI User Auth Token**, and OCI generates Auth Tokens with special characters.

## Deploy the infrastructure

Clone repository:

```bash
git clone https://github.com/vmleon/oci-devops-secrets.git
```

Change to the cloned directory:

```bash
cd oci-devops-secrets
```

Copy `terraform.tfvars` from the template.

```bash
cp terraform/terraform.tfvars.template terraform/terraform.tfvars
```

Edit `terraform.tfvars` to fit your environment.

```bash
vim terraform/terraform.tfvars
```

> 
> NOTE:
>
> List region names:
> ```bash
> oci iam region-subscription list --query 'data[]."region-name"'
> ```
> 
> Search for Tenancy OCID:
> ```bash
> oci iam compartment list --query 'data[0]."compartment-id"'
> ```
> 
> Search for a Compartment OCID by `COMPARTMENT_NAME`:
> ```bash
> oci iam compartment list --all \
>    --compartment-id-in-subtree true \
>    --query "data[].id" --name "COMPARTMENT_NAME"
> ```
> 


Change to the `terraform` directory:

```bash
cd terraform
```

Run terraform `init`.

```bash
terraform init
```

Run terraform `apply`.

```bash
terraform apply -auto-approve
```

## The issue error message

When the deployment is finished, go to **Menu** > **Developer Services** > **OCI DevOps**.

Access the **DevOps project** and click on the **Deployment Pipeline**.

Click **Run pipeline** and **Start manual run** on the next screen, then wait for the error.

## Clean up

Run the terraform destroy:

```bash
terraform destroy -auto-approve
```

Error message `syntax error near unexpected token ('` and ``BAD_SECRET=qwe<rt(y=123'`:
```
Starting EXECUTING_COMMAND_SPEC_STEPS   
Executing SPEC_STEP : GOOD_SECRET   
Executing step: GOOD_SECRET with shell type: bash, user: root, timeout: 10000   
EXEC: Warning: Permanently added '[localhost]:2020' (ED25519) to the list of known hosts.   
EXEC: /shared/docker-vol/agent-dir/ext/script/COMMAND_SPEC_SECRET_VARIABLES: line 2: syntax error near unexpected token `('   
EXEC: /shared/docker-vol/agent-dir/ext/script/COMMAND_SPEC_SECRET_VARIABLES: line 2: `BAD_SECRET=qwe<rt(y=123'   
Step 'GOOD_SECRET' failed with exit code: '2', please check the commands on the build spec file.   
Failed executing step : GOOD_SECRET, proceeding to execute the onFailure block.   
SHELL_EXECUTION Failed.
```
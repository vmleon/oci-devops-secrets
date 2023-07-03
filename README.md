# OCI DevOps Secrets

This repository is a minimal complete verifiable issue report.

OCI DevOps fails when reading OCI Vault secrets with special character content.

This report uses Terraform to deploy **Vault**, **Master key** and two **Secrets**. It also deploys **DevOps Project** and **Deployment Pipeline** with a `command_spec.yaml` that read the secret content from the secret OCID.

```yaml
env:
  vaultVariables:
    GOOD_SECRET: ${good_secret_id}
    BAD_SECRET: ${bad_secret_id}
```

Good Secret content: `abcde123`
Bad Secret content: `qwe<rt(y=123`

The content can be changed with a terraform variable in `terraform.tfvars`:
- `good_secret_content`
- `bad_secret_content`

This issue is important because the secret could be an **OCI User Auth Token**, and OCI generates Auth Tokens with special characters.

## Run issue

>
> NOTE:
> 
> These steps have been tested on OCI Cloud Shell.
> 

Clone repository:

```bash
git clone git@github.com:vmleon/oci-devops-secrets.git
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


Run terraform `init`.

```bash
terraform init
```

Run terraform `apply`.

```bash
terraform apply -auto-approve
```

When the deployment is finished, go to **Menu** > **Developer Services** > **OCI DevOps**.

Access the **DevOps project** and click on the **Deployment Pipeline**.

**Manually run the pipeline** and wait for the error.

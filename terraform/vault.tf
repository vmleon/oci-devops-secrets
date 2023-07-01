resource "oci_kms_vault" "vault_devops" {
  compartment_id = var.compartment_ocid
  display_name   = "vault_${random_string.deploy_id.result}"
  vault_type     = "DEFAULT" // VIRTUAL_PRIVATE, DEFAULT
}

resource "oci_kms_key" "master_key_devops" {
  compartment_id = var.compartment_ocid
  display_name   = "master_key_devops_${random_string.deploy_id.result}"
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = oci_kms_vault.vault_devops.management_endpoint
}

resource "oci_vault_secret" "good_secret" {
  compartment_id = var.compartment_ocid
  secret_content {
    name         = "good_secret_${random_string.deploy_id.result}"
    content      = base64encode(var.good_secret_content)
    content_type = "BASE64"
    stage        = "CURRENT"
  }
  vault_id = oci_kms_vault.vault_devops.id
  key_id   = oci_kms_key.master_key_devops.id

  secret_name = "good_secret_${random_string.deploy_id.result}"
  description = "Good Secret for ${random_string.deploy_id.result}"
}

resource "oci_vault_secret" "bad_secret" {
  compartment_id = var.compartment_ocid
  secret_content {
    name         = "bad_secret_${random_string.deploy_id.result}"
    content      = base64encode(var.bad_secret_content)
    content_type = "BASE64"
    stage        = "CURRENT"
  }
  vault_id = oci_kms_vault.vault_devops.id
  key_id   = oci_kms_key.master_key_devops.id

  secret_name = "bad_secret_${random_string.deploy_id.result}"
  description = "Bad Secret for ${random_string.deploy_id.result}"
}

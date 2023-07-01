
output "deploy_id" {
  value = random_string.deploy_id.result
}

output "compartment" {
  value = data.oci_identity_compartment.compartment.name
}

output "good_secret" {
  sensitive = true
  value     = oci_vault_secret.good_secret.secret_content[0].content
}

output "good_secret_id" {
  value = oci_vault_secret.good_secret.id
}

output "bad_secret" {
  sensitive = true
  value     = oci_vault_secret.bad_secret.secret_content[0].content
}

output "bad_secret_id" {
  value = oci_vault_secret.bad_secret.id
}

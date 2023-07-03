locals {
  dynamic_group_name = "devops_dynamic_group_${random_string.deploy_id.result}"
}

resource "oci_identity_dynamic_group" "devops_dynamic_group" {
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  description    = "DevOps Dynamic Group for ${random_string.deploy_id.result}"
  matching_rule  = "ANY { ALL { resource.type = 'instance-family', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}, ALL { resource.type = 'devopsdeployment', resource.compartment.id = '${var.compartment_ocid}'} }"
  name           = local.dynamic_group_name
}


resource "oci_identity_policy" "devops_policy_in_tenancy" {
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  name           = "devops_policies_tenancy_${random_string.deploy_id.result}"
  description    = "Allow dynamic group to manage devops at tenancy level for ${random_string.deploy_id.result}"
  statements = [
    "allow dynamic-group ${local.dynamic_group_name} to manage devops-family in tenancy",
    "allow dynamic-group ${local.dynamic_group_name} to manage repos in tenancy",
  ]
}

resource "oci_identity_policy" "devops_policy_in_compartment" {
  provider       = oci.home_region
  compartment_id = var.compartment_ocid
  name           = "devops_policies_${random_string.deploy_id.result}"
  description    = "Allow dynamic group to manage devops for ${random_string.deploy_id.result}"
  statements = [
    "allow dynamic-group ${local.dynamic_group_name} to use virtual-network-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-container-instances in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to manage compute-containers in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to read secret-family in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use dhcp-options in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use ons-topics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use subnets in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use vnics in compartment id ${var.compartment_ocid}",
    "allow dynamic-group ${local.dynamic_group_name} to use network-security-groups in compartment id ${var.compartment_ocid}",
  ]
}

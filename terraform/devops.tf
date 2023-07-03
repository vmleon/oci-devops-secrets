resource "oci_logging_log_group" "devops_log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "devops_log_group_${random_string.deploy_id.result}"
}

resource "oci_logging_log" "devops_log" {
  display_name = "devops_log_${random_string.deploy_id.result}"
  log_group_id = oci_logging_log_group.devops_log_group.id
  log_type     = "SERVICE"
  configuration {
    source {
      category    = "all"
      resource    = oci_devops_project.devops_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }
    compartment_id = var.compartment_ocid
  }
  is_enabled         = true
  retention_duration = 10
}

resource "oci_devops_project" "devops_project" {
  compartment_id = var.compartment_ocid
  name           = "devops_project_${random_string.deploy_id.result}"
  notification_config {
    topic_id = oci_ons_subscription.devops_ons_subscription.id
  }
  description = "DevOps Project for ${random_string.deploy_id.result}"
}

terraform {
  required_providers {
    oci = {
      source                = "oracle/oci"
      version               = "~> 4.121"
      configuration_aliases = [oci.home_region]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
      # https://registry.terraform.io/providers/hashicorp/random/
    }
  }
}

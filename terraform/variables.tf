variable "config_file_profile" {
  type    = string
  default = "DEFAULT"
}

variable "tenancy_ocid" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "subscription_email" {
  type = string
}

variable "good_secret_content" {
  type    = string
  default = "abcde123"
}

variable "bad_secret_content" {
  type    = string
  default = "qwe<rt(y=123"
}

variable "TFC_ORGANIZATION" {}

variable "hostname" {
  default   = "app.terraform.io"
  sensitive = true
}

variable "token" {}
variable "oauthtoken" {}

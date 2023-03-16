variable "TFC_ORGANIZATION" {
  description = "Terraform cloud organization name"
}

variable "hostname" {
  default   = "app.terraform.io"
  sensitive = true
}

variable "github-user" {
  description = "your github user"
}

variable "token" {
  description = "Terraform Cloud api token"
}

variable "oauthtoken" {
  description = "GitHub user token"
}

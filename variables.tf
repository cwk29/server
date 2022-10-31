variable "tfc_org_name" {
  type    = string
  default = "wortech"
}

variable "tfc_networking_workspace_name" {
  type    = string
  default = "networking-dev"
}

variable "mongo_username" {
  type    = string
  default = ""
}

variable "mongo_password" {
  type    = string
  default = ""
}

variable "nodemailer_username" {
  type    = string
  default = ""
}

variable "nodemailer_password" {
  type    = string
  default = ""
}

variable "trusted_accounts" {
  description = "A list of AWS Account IDs you want to allow them access to the ECR repository"
  type        = list(string)
  default     = ["arn:aws:iam::060696402958:user/ckuykendall@wortechcorp.com"]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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

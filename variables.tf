variable "name" {
  description = "base name for naming and tagging resources"
}
variable "public_subnets" { default = "" }
variable "private_subnets" { default = "" }
variable "availability_zones" {
  description = "The availability zones to create subnets in"
}
variable "vpc_id" {
  description = "The ID of the VPC that has already been created"
}
variable "env" {
  description = "environment name, for use in tags"
  default = ""
}
variable "project" {
  description = "project name, for use in tags"
  default = ""
}

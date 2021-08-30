# You can utilize these two CloudShare built-in variables for your other resources

variable "CS_Owner_Email" {}
variable "CS_Env_Id" {}
 
output "email" {
  value = "${var.CS_Owner_Email}"
}
 
output "envId" {
  value = "${var.CS_Env_Id}"
}

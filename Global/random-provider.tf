resource "random_string" "resource_code" {
   length  = 5
   special = false
   upper   = false
 }
 
output "random_value" {
    value = "${random_string.resource_code.result}"
}

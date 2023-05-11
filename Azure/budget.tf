# Edit the following parameters:
#  email_reciever
#  contact_emails
#
# start_date will generate the first day of the current month, and end_date will generate the first day of the next month
# To manually set the dates, use the following date format:
# "YYYY-MM-01T00:00:00Z"
# Azure requires the start_date to be the first day of the month
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group
#
# This example will alert when 80% of the 5% usage is met by sending an email.

resource "azurerm_monitor_action_group" "example" {
  name                = "BudgetActionGroup"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  short_name          = "ag"

  email_receiver {
    name                    = "yourname"
    email_address           = "your@email.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_consumption_budget_resource_group" "Monthly_budget" {
  name              = "monthlybudget"
  resource_group_id = "${data.azurerm_resource_group.main.id}"

  amount     = 5
  time_grain = "Monthly"

  time_period {
	  start_date = formatdate("YYYY-MM-01'T00:00:00Z'",timestamp())
	  # 31 days from today 
	  end_date = formatdate("YYYY-MM-DD'T00:00:00Z'",timeadd(timestamp(),"744h"))
	  # Beginning of next month if preferred
	  #end_date = formatdate("YYYY-MM-01'T00:00:00Z'",timeadd(formatdate("YYYY-MM-01'T00:00:00Z'",timestamp()),"744h"))
  }
  
  notification {
    enabled        = true
    threshold      = 80.0
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"
  
	
	contact_emails = [
	 "your@email.com"
    ]  
    
    contact_groups = [
      azurerm_monitor_action_group.example.id,
    ]

}
}

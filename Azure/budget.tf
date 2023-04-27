# Edit the following parameters:
#  time_period section - update start_date to the current month, end_date to next month.
#  email_reciever
#  contact_emails
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
    start_date = "2023-04-01T00:00:00Z"
    end_date   = "2023-05-01T00:00:00Z"
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

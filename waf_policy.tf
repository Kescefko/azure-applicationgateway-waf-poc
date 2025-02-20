resource "azurerm_application_gateway_waf_policy" "example_waf_policy" {
  name                = "example-waf-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  

  custom_rules {
    name     = "block_sql_injection"
    priority = 1
    rule_type = "MatchRule"
    action   = "Block"
    match_conditions {
      match_variable = "RequestHeader"
      operator       = "Contains"
      match_values   = ["' OR 1=1 --", "DROP TABLE"]
    }
  }

  rule_set {
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  managed_rules {
    enabled = true
    rule_set_type = "OWASP"
    rule_set_version = "3.2"
  }
}

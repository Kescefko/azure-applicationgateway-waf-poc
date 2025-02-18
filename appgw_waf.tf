resource "azurerm_public_ip" "appgw_pip" {
  name = "appgw-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  allocation_method = "Static"
}

resource "azurerm_application_gateway" "appgw" {
  name = "poc-appgw"
  resource_group_name = azurerm_resource_group.poc.name
  location = azurerm_resource_group.poc.location

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name = "appgw-ipconfig"
    subnet_id = azurerm_subnet.subnet_appgw.id
  }

  frontend_ip_configuration {
    name = "appgw-frontend"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "backend-pool"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  http_listener {
    name = "http-listener"
    frontend_ip_configuration_name = "appgw-frontend"
    frontend_port_name = "http-port"
    protocol = "Http"
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  request_routing_rule {
    name = "http-rule"
    rule_type = "Basic"
    http_listener_name = "http-listener"
    backend_address_pool_name = "backend-pool"
    backend_http_settings_name = "http-settings"
  }

  backend_http_settings {
    name = "http-settings"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 20
  }

  waf_configuration {
    enabled = true
    firewall_mode = "Prevention"
    rule_set_type = "OWASP"
    rule_set_version = "3.2"
  }
}

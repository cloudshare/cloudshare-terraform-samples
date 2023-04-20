# The new syntax for Terraform versions 0.14 - 1.3.2

variable "prefix" {
  default = "cloudshare"
}

resource "azurerm_public_ip" "publicip" {  
  name                         = "windows-2016"  
  location                     = "${data.azurerm_resource_group.main.location}"  
  resource_group_name          = "${data.azurerm_resource_group.main.name}"  
  allocation_method = "Dynamic"  
  idle_timeout_in_minutes      = 30  
  
  tags = {  
    environment = "test"  
  }  
}  
  
resource "azurerm_virtual_network" "vnet" {   
  name                = "${var.prefix}-network"  
  address_space       = ["10.0.0.0/16"]  
  location            = "${data.azurerm_resource_group.main.location}"  
  resource_group_name = "${data.azurerm_resource_group.main.name}"  
}  
  
resource "azurerm_network_security_group" "nsg" {  
  name                = "${var.prefix}-nsg"  
  location            = "${data.azurerm_resource_group.main.location}"  
  resource_group_name = "${data.azurerm_resource_group.main.name}"  

  
    security_rule {   
    name                       = "allout"  
    priority                   = 100  
    direction                  = "Outbound"  
    access                     = "Allow"  
    protocol                   = "*"  
    source_port_range          = "*"  
    destination_port_range     = "*"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
  
  security_rule {   
    name                       = "allin"  
    priority                   = 110  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "*"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  } 
  tags = {  
    environment = "test"  
  }  
}  
  
resource "azurerm_subnet" "subnet" {  
  name                 = "${var.prefix}-subnet"  
  resource_group_name  = "${data.azurerm_resource_group.main.name}"  
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"  
  address_prefixes       = ["10.0.2.0/24"]
}  
  
resource "azurerm_network_interface" "winnic" {  
  name                      = "${var.prefix}-winnic"  
  location                  = "${data.azurerm_resource_group.main.location}"  
  resource_group_name       = "${data.azurerm_resource_group.main.name}"  

  ip_configuration {  
    name                          = "${var.prefix}-configuration"  
    subnet_id                     = "${azurerm_subnet.subnet.id}"  
    private_ip_address_allocation = "Dynamic"  
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"  
  }  
}  
  
resource "azurerm_managed_disk" "datadisk" { 
  name                 = "${var.prefix}-datadisk"  
  location             = "${data.azurerm_resource_group.main.location}"  
  resource_group_name  = "${data.azurerm_resource_group.main.name}"  
  storage_account_type = "Standard_LRS"  
  create_option        = "Empty"  
  disk_size_gb         = "1023"  
}  
  
resource "azurerm_virtual_machine" "windows" {  
  name                  = "Azure-windows-2012"  
  location              = "${data.azurerm_resource_group.main.location}"  
  resource_group_name   = "${data.azurerm_resource_group.main.name}"  
  network_interface_ids = ["${azurerm_network_interface.winnic.id}"]  
  vm_size               = "Standard_A2"
  
  storage_image_reference {  
    publisher = "MicrosoftWindowsServer"  
    offer     = "WindowsServer"  
    sku       = "2012-R2-Datacenter"  
    version   = "latest" 
  }  
  
  storage_os_disk { 
    name              = "${var.prefix}-osdisk"  
    caching           = "ReadWrite"  
    create_option     = "FromImage"  
    managed_disk_type = "Standard_LRS"  
  }  
  
  storage_data_disk {  
    name            = "${azurerm_managed_disk.datadisk.name}"  
    managed_disk_id = "${azurerm_managed_disk.datadisk.id}"  
    create_option   = "Attach"  
    lun             = 1  
    disk_size_gb    = "${azurerm_managed_disk.datadisk.disk_size_gb}"  
  }  
  
  os_profile {  
    computer_name  = "${var.prefix}-host"  
    admin_username = "testadmin" 
    admin_password = "Password1234!"  
  }  
  
  os_profile_windows_config {  
    enable_automatic_upgrades = true  
    provision_vm_agent        = true  
  
    winrm {  
      protocol = "HTTP"  
    }  
  }  
}

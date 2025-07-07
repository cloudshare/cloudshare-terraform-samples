# Change vm_size to your needs
# Change the the URL path of "fileUris"
# Change the script name of "commandToExecute"

variable "prefix" {
  default = "cloudshare"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${data.azurerm_resource_group.main.location}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.prefix}-configuration"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "vnet" { 
  name                = "${var.prefix}-network"  
  address_space       = ["10.0.0.0/16"]  
  location            = "${data.azurerm_resource_group.main.location}"  
  resource_group_name = "${data.azurerm_resource_group.main.name}"  
}  
  
resource "azurerm_subnet" "subnet" {   
  name                 = "${var.prefix}-subnet"  
  resource_group_name  = "${data.azurerm_resource_group.main.name}"  
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"  
  address_prefixes       = ["10.0.2.0/24"] 
}  
  
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-ubuntu-24"
  location              = "${data.azurerm_resource_group.main.location}"

  resource_group_name   = "${data.azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_B1ls"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  storage_os_disk {
    name              = "linuxosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine_extension" "myterraformvm" {
  name = "cloud-share-startup"
  virtual_machine_id = azurerm_virtual_machine.main.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
  { 
    "fileUris": [ 
          "https://raw.githubusercontent.com/<OWNER>/<REPO>/<BRANCH>/<SCRIPT_NAME.SH>"
        ],
    "commandToExecute": "/bin/bash <SCRIPT_NAME.SH>"
  }
  SETTINGS
}

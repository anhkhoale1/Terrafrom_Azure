# Create virtual network
resource "azurerm_virtual_network" "akl_terraform_network" {
  name                = "AKLVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.multipleresource[7].location
  resource_group_name = azurerm_resource_group.multipleresource[7].name
}

# Create subnet
resource "azurerm_subnet" "akl_terraform_subnet" {
  name                 = "AKLSubnet"
  resource_group_name  = azurerm_resource_group.multipleresource[7].name
  virtual_network_name = azurerm_virtual_network.akl_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create network interface
resource "azurerm_network_interface" "akl_terraform_nic" {
  name                = "AKLNIC"
  location            = azurerm_resource_group.multipleresource[7].location
  resource_group_name = azurerm_resource_group.multipleresource[7].name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.akl_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.akl_terraform_public_ip.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "akl_terraform_public_ip" {
  name                = "AKLPublicIP"
  location            = azurerm_resource_group.multipleresource[7].location
  resource_group_name = azurerm_resource_group.multipleresource[7].name
  allocation_method   = "Dynamic"
}

# Create virtual machine
resource "azurerm_virtual_machine" "akl_terraform_vm" {
  name                  = "AKLVM"
  location              = azurerm_resource_group.multipleresource[7].location
  resource_group_name   = azurerm_resource_group.multipleresource[7].name
  network_interface_ids = [azurerm_network_interface.akl_terraform_nic.id]
  vm_size                  = "Standard_DS1_v2"

   storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
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
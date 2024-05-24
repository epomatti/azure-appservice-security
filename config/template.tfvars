### General ###
location = "eastus2"

### App Service ###
webapp_plan_sku_name   = "P1v3"
webapp_deploy_from_acr = true

# AFD routing
app1_path = "/app1"
app2_path = "/app2"
app3_path = "/app3"

### Front Door ###
frontdoor_sku_name = "Premium_AzureFrontDoor"

### Virtual Machine ###
vm_linux_size      = "Standard_B2ps_v2"
vm_linux_image_sku = "22_04-lts-arm64"

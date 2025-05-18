### General ###
subscription_id = "00000000-0000-0000-0000-000000000000"
location        = "eastus2"

### App Service ###
webapp_plan_sku_name   = "P1v3" # V2 is legacy now, althouhg it was cheaper for the same name pattern
webapp_deploy_from_acr = true

# AFD routing
app1_path = "/app1"
app2_path = "/app2"
app3_path = "/app3"

### Front Door ###
deploy_frontdoor   = false
frontdoor_sku_name = "Premium_AzureFrontDoor"

### Virtual Machine ###
vm_key_path        = ".keys/tmp_rsa.pub"
vm_linux_size      = "Standard_B2ps_v2"
vm_linux_image_sku = "22_04-lts-arm64"

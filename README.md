# Azure App Service Security

Implementation of Azure App Service security features.

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Next, approve the Private Endpoint created by Front Door on behalf of App Service.

## Access Restriction

Controls inbound connectivity. Functionality available when Public Access is set to **TRUE**.

Access can be controlled to the main site and the SCM (Advanced). Advanced can inherit rules from main.

This Terraform configuration will set up automatically ALLOW for:

- Service Tag: `AzureFrontDoor.Backend`
- HTTP Header: `X-Azure-FDID`

<img src=".assets/appservice-rules.png" />

Do set `Deny` as the unmatched rule:

```sh
az resource update --resource-group rg-bigfactory --name app-bigfactory --resource-type "Microsoft.Web/sites" \
    --set properties.siteConfig.ipSecurityRestrictionsDefaultAction=Deny
```

## Service Endpoints

It is possible to use the Azure backbone to access an App Service from a VM or other services.

This Terraform project automatically configures `Microsoft.Web` service endpoints for the VM subnet. Running Network Watcher will give the "next hop type" `VirtualNetworkServiceEndpoint`.

When removing the service endpoint, the next hop type will be `Internet`.

## Private Endpoints

Couple of [benefits][1]:

- Avoid public endpoints
- Minimize the possibility of data exfiltration
- On-premises


Set `create_private_endpoint_flag` to `true` to enable the private endpoint:

```terraform
create_private_endpoint_flag = true
```

## Front Door latency benchmark

This project will create three apps to measure differences in latency:

- **App 1** - AFD route with public endpoint.
- **App 2** - AFD route with private endpoint.
- **App 3** - No AFD, direct connection to the public endpoint.


```sh
export acr="crbigfactory"
```

Build and push the custom application:

```
cd app
bash acr-build-push.bash
```

Back to the root directory, change the configuration to pull from ACR:

```sh
webapp_deploy_from_acr = true
```

Apply:

```sh
terraform apply -auto-approve
```

Test the routes and measure the latency.

## Virtual Network Integration

Only one VNET injection is supported.

---

### Clean-up

Once done, delete the resources:

```sh
terraform destroy -auto-approve
```

[1]: https://learn.microsoft.com/en-us/azure/private-link/private-link-overview#key-benefits

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

## VNET Integration

Only one VNET injection is supported.

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

---

### Clean-up

Once done, delete the resources:

```sh
terraform destroy -auto-approve
```

[1]: https://learn.microsoft.com/en-us/azure/private-link/private-link-overview#key-benefits

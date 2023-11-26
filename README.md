# azure-appservice-security

Azure App Service security features

## Access Restriction

Controles inbound connectivity, and it comes available when Public Access is set to **TRUE**.

Access can be controlled to the main site and the SCM (Advanced). Advanced can inherit rules from main.

```sh
az resource update --resource-group rg-bigfactory --name app-bigfactory --resource-type "Microsoft.Web/sites" \
    --set properties.siteConfig.ipSecurityRestrictionsDefaultAction=Deny
```

## Front Door security

### Private Link

Requires Front Door with Premium SKU.

### 

## VNET Integration

Only one is supported.

## before you terraform 
1. Create an Application 
2. go to subscription and add the role of Contributor 
3. collect these variables:
export ARM_CLIENT_ID=39186a11-50be-4f4b-acc8-b67d69ba16a2
export ARM_CLIENT_SECRET=
export ARM_TENANT_ID=20b3c169-...
export ARM_SUBSCRIPTION_ID=21935bdc-...
4. Add them to you bash_profile

## Learned the hard way:
1. It matters where you put  `custom_data = filebase64("customdata.tpl")` as an attribute in your vm resource in Azure
Specifically, adminuser was not being added to the docker group when provisioning the vm.
2. Not really true (1), no idea why it worked. Problem seemed to be in the script itself. 

### Terraform shortcuts

#### Init, plan apply
`terraform init` `terraform fmt`

`terrafrom plan` `terraform plan -out iaka`

`terraform apply "iaka"`

#### verify
`terraform state list`

`terraform state show <resource>`

#### Update / Destroy resources
`terraform plan -destroy`

`terraform apply -destroy`

`terraform apply -replace <resource>`

`terraform plan -var="vm_size=Standard_B2s" -out iaka`

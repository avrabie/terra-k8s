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

#!/bin/bash
terraform plan -var="vm_size=Standard_B2s" -out create_cluster
terraform apply create_cluster
rm create_cluster
terraform refresh

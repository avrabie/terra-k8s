#!/bin/bash
terraform plan -out create_cluster
terraform apply create_cluster
rm create_cluster
terraform refresh

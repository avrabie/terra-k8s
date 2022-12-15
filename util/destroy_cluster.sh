#!/bin/bash
terraform plan -destroy -out shutdown
terraform apply shutdown
rm shutdown

#!/bin/zsh

vm="${1:-vm1}" #by default we assume your vm name is vm1
echo "Finding IP of: $vm"
res1=$(terraform state list | grep $vm)
res2=$(terraform state show $res1 | grep public_ip_address) #kernel
vm1_ip=$(echo $res2 | grep -o '".*"' | sed 's/"//g') # extracting IP
echo "IP Found: $vm1_ip"
printf $vm1_ip | pbcopy #you're welcome

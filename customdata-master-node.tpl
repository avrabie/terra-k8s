#!/bin/bash
#install docker
sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
sudo apt-get update -y &&
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo groupadd docker
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock


sudo swapoff --all
wget https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo apt-key add apt-key.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update -y
sudo apt-get install kubeadm kubelet kubectl kubernetes-cni socat -y

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init
#sudo kubeadm init --upload-certs --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
mkdir /home/adminuser/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /home/adminuser/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo chown $(id -u):$(id -g) /home/adminuser/.kube/config
sudo chown 1000:1000 /home/adminuser/.kube/config
export KUBECONFIG=/home/adminuser/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubeadm token create --print-join-command

#!/bin/bash

# change MASTER_IP to IP of you master machine
export MASTER_IP=188.166.115.138

# updating packages
apt-get update && apt-get upgrade -y

# add repository of kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -y


# install docker and kubernetes
apt-get install -y docker.io
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# init kubeadm (create master kubernetes node)
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $MASTER_IP

# add kubectl config to environment
export KUBECONFIG=/etc/kubernetes/admin.conf

# configure and start overlay network (flannel)
sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# install and deploy dashboard
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml --namespace=kube-system


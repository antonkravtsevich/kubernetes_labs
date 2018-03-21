#!/bin/bash

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

# join to cluster
kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>

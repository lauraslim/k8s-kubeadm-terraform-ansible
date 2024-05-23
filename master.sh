#!/bin/bash
set -e
#set hostname
echo "--------------Setting hostname------------"
hostnamectl set-hostname $1

#disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#install containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.13/containerd-1.7.13-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.7.13-linux-amd64.tar.gz
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system
mv containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

#Install Runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

#install cni
wget https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.4.0.tgz

#install crictl
VERSION="v1.29.0" # check latest version in /releases page
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF

#Forwarding IPv4 and letting iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
modprobe br_netfilter
sysctl -p /etc/sysctl.conf

#Install kubectl, kubelet and kubeadm
echo "--------------installing kubectl, kubelet and kubeadm-----------"
apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#Check kubeadm version
kubeadm version

#pulling kubeadm image and reinitializing kubeadm
kubeadm config images pull
kubeadm init

#copying kubeconfig
mkdir -p /root/.kube
cp -iv /etc/kubernetes/admin.conf /root/.kube/config
sudo chown $(id -u):$(id -g) /root/.kube/config

#exporting kubeconfig
export KUBECONFIG=/etc/kubernetes/admin.conf

#deploy weavenet pod networking:Install any CNI plugin. We will use weavenet
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset.k8s.yaml

#create file with join command
echo `kubeadm token create --print-join-command` > ./join-command.sh


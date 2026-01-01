- Prerequisites

## Step 1. Prepare all nodes (control plane + workers)

### 1.1 Disable swap

```bash
1. Ensure required ports are open

#On control-plane
nc -l 6443  

#On worker nodes
nv -v <control-plane-private-ip> 6443 

2. Turn off swap on all the nodes

sudo swapoff -a 

3. Disable swap permanently(optional but preferred)

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 

4. Verify swap is off

free -h
```

### 1.2 load required kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
>overlay
>br_netfilter
>EOF

#Apply modules
```bash
sudo modprobe overlay
sudo modprobe br_netfilter

#verify modules are loaded
lsmod | grep -i br_netfilter
lsmod | grep -i overlay
```

### 1.3 configure kernel parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
>net.bridge.bridge-nf-call-iptables = 1
>net.bridge.bridge-nf-call-ip6tables = 1
>net.ipv4.ip_forward = 1
>EOF

#Apply settings
```bash
sudo sysctl --system
```
#Verify kernel parameters are applied

```bash
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```
## Step 2: Install container runtime(containerd)


### 2.1 Install container runtime

```bash
#Update package index
sudo apt-get update

#Install dependencies
sudo apt-get install -y apt-transport-https curl ca-certificates software-properties-common

#Add docker repositories

#Install containerd
sudo apt-get update 
suod apt-get install -y containerd.io

```
### 2.2 Configure containerd

```bash
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

```

## Step 3: Install kubeadm, kubelet and kubectl

### 3.1 Add kubernetes repository

```bash
sudo apt-get update

#Add kubenetes repository


```

### 3.2 Install, hold kubernetes components; enable kubelet

```bash

#Install specific version
sudo apt-get install -y kubelet=1.29.0-1.1 kubeadm=1.29.0-1.1 kubectl=1.29.0-1.1

#hold packages to prevent auto-updates
sudo apt-mark hold kubelet kubeadm kubectl

#enable kubelet service
sudo systemctl enable --now kubelet

```


## Step 4: Initialize Control Plane

### 4.1 Initialize cluster

```bash
#Default CIDR during initialisation
# For Calico
# --pod-network-cidr=192.168.0.0/16

#For Flannel
# --pod-network-cidr=10.244.0.0/16

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

```
### 4.2 Save the join command

```bash
#Save join command and further steps listed at the end of initialisation
```


### 4.3 Verify control plane

```bash

kubectl get componentstatuses

kubectl get nodes

kubectl get pods -n kube-system

```

## Step 5: Install CNI plugin

### 5.1 Install Calico/Flannel based on pod-network-cidr initialized

```bash
#Calico installation

# Install Calico operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

# Install Calico custom resources
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

kubectl get pods -n calico-system

```


## Step 6: Join worker nodes

```bash

#Use the join command generated earlier during kubeadm init to join worker nodes

#Generate new token if previous command is unavailable
kubeadm token create --print-join-command

```
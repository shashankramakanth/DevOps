## Step 0: Pre-Upgrade Checklist

### 0.1: Check current version

```bash

   kubectl version --short
   kubectl get nodes
```

### 0.2: backup etcdctl

```bash
ETCDCTL_API=3 etcdctl snapshot save backup.db \
     --endpoints=https://127.0.0.1:2379 \
     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt \
     --key=/etc/kubernetes/pki/etcd/server.key
```

### 0.3: Check API deprecations

```bash
kubectl get all --all-namespaces -o yaml | grep -i "apiVersion"
```

## Step 1: Update the package repository (on control-planes and worker nodes)
```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

```
## Step 2: Install kubeadm on control plane

```bash
#unhold kubeadm
sudo apt-mark unhold kubeadm

#update and install
sudo apt-get update && apt-get install kubeadm=1.30.0-1.1

#hold kubeadm
sudo apt-mark hold kubeadm


```

## Step 3: Upgrade kubeadm on control plane

```bash
#Plan the upgrade
kubeadm upgrade plan

#Use the upgrade command generated to apply change
kubeadm upgrade apply v1.30.0

```

## Step 4: Install kubelet & kubectl on control plane

```bash
#Drain the node
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data

#unhold kubelet & kubectl
sudo apt-mark unhold kubelet kubectl

#install kubelet and kubectl
sudo apt-get update && apt-get install -y kubelet=1.30.0-1.1 kubectl=1.30.0-1.1

#hold kubelet & kubectl
sudo apt-mrk hold kubelet kubectl

#restart services
sudo systemctl daemon-reload
sudo systemctl restart kubelet

#uncordon the node
sudo kubectl uncordon <node>

```


## Step 4: Upgrade kubelet & kubectl on worker nodes


```bash
#Drain the node
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data

#unhold kubelet & kubectl
sudo apt-mark unhold kubelet kubectl

#install kubelet and kubectl
sudo apt-get update && apt-get install -y kubelet=1.30.0-1.1 kubectl=1.30.0-1.1

#hold kubelet & kubectl
sudo apt-mrk hold kubelet kubectl

#restart services
sudo systemctl daemon-reload
sudo systemctl restart kubelet

#uncordon the node
sudo kubectl uncordon <node>

```
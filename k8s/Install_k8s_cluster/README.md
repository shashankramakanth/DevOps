## Install Multipass
-> Use multipass to create ubuntu VMs on windows

1. **Download and install Multipass**:
   - Go to https://multipass.run/
   - Download the Windows installer
   - Run the installer and follow the prompts

## Create VMs for Kubernetes

2. **Create the control plane (master) VM**:
   ```powershell
   multipass launch --name k8s-master --cpus 2 --mem 2G --disk 10G
   ```

3. **Create worker node VMs**:
   ```powershell
   multipass launch --name k8s-worker1 --cpus 2 --mem 2G --disk 10G
   multipass launch --name k8s-worker2 --cpus 2 --mem 2G --disk 10G
   ```

4. **View your VMs**:
   ```powershell
   multipass list
   ```

## Configure the VMs

5. **Access the master VM**:
   ```powershell
   multipass shell k8s-master
   ```

6. **Inside each VM, update and prepare for Kubernetes**:
   ```bash
   # Update the system
   sudo apt update && sudo apt upgrade -y
   
   # Disable swap
   sudo swapoff -a
   sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
   
   # Load required modules
   cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
   overlay
   br_netfilter
   EOF
   
   sudo modprobe overlay
   sudo modprobe br_netfilter
   
   # Set up required sysctl params
   cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
   net.bridge.bridge-nf-call-iptables  = 1
   net.bridge.bridge-nf-call-ip6tables = 1
   net.ipv4.ip_forward                 = 1
   EOF
   
   sudo sysctl --system
   ```

7. **Find IP addresses of your VMs**:
   ```powershell
   multipass info --all
   ```

8. **Set up host entries in each VM**:
   - From your master VM:
   ```bash
   sudo nano /etc/hosts
   ```
   - Add entries for each VM using the IPs from the previous step:
   ```
   192.168.x.x k8s-master
   192.168.x.x k8s-worker1
   192.168.x.x k8s-worker2
   ```
   - Repeat for worker VMs

## Install Kubernetes Components

9. **Install Containerd and Kubernetes components on all VMs**:
   ```bash
    # Install containerd
    sudo apt install -y containerd

    # Create default configuration
    sudo mkdir -p /etc/containerd
    sudo containerd config default | sudo tee /etc/containerd/config.toml

    # Update the configuration to use systemd cgroup driver
    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

    # Restart containerd
    sudo systemctl restart containerd
    sudo systemctl enable containerd
   
   # Add Kubernetes repo
   sudo apt install -y apt-transport-https ca-certificates curl
   curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
   echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
   
   # Install kubeadm, kubelet, kubectl
   sudo apt update
   sudo apt install -y kubelet kubeadm kubectl
   sudo apt-mark hold kubelet kubeadm kubectl
   ```

## Initialize the Cluster

10. **On the master node, initialize the cluster**:
    ```bash
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    ```

11. **Set up kubectl on the master**:
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

12. **If running as root**
    ```bash
    export KUBECONFIG=/etc/kubernetes/admin.conf

13. **Install a CNI plugin (Flannel)**:
    ```bash
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
    ```
14. **Alternately, weave-net can be installed**
    ```bash
    kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

15. **Edit weave-net configuration to include container IPMALLOC**
    **Edit the following spec section in yaml file**
    kubectl edit ds weave-net -n kube-system
    ```yaml
    spec:
        containers:
        - command:
          - /home/weave/launch.sh
          env:
          - name: IPALLOC_RANGE
            value: 10.244.0.0/16

16. **Join worker nodes to the cluster**:
    - Copy the join command output from the kubeadm init command
    - Run that command on each worker node with sudo

17. **Check cluster status on the master**:
    ```bash
    kubectl get nodes
    ```

Multipass is much more convenient than manually setting up VMs with VirtualBox or Hyper-V, as it handles most of the VM creation and networking details automatically. It's perfect for testing Kubernetes in a multi-node setup on a Windows PC.
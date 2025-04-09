vim /etc/apt/sources.list.d/kubernetes.list
#Update the version in the URL to the next available minor release, i.e v1.32.

deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
#After making changes, save the file and exit from your text editor. Proceed with the next instruction.

apt update

apt-cache madison kubeadm
#Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.32.0, the available package version is 1.32.0-1.1. Therefore, to install kubeadm for Kubernetes v1.32.0, use the following command:

apt-get install kubeadm=1.32.0-1.1

kubeadm upgrade node

#Now, upgrade the Kubelet version. Also, mark the node (in this case, the "<node-name>" node) as schedulable.

apt-get install kubelet=1.32.0-1.1
#Run the following commands to refresh the systemd configuration and apply changes to the Kubelet service:

systemctl daemon-reload

systemctl restart kubelet
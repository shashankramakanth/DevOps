**TLS certificates:**

server certificates in Kubernetes:

- kube-apiserver: apiserver.crt, apiserver.key
    - exposes an https service for clients to communicate
    - only server that communicates with ETCD server
- ETCD server: etcdserver.crt etcdserver.key
    - Stores all the information about the cluster
- On worker nodes - Kubelet server: kubelet.crt kubelet.key
    - exposes an https endpoint

Client certificates: All these services comunicate with kube-api server

- admin: admin.crt, admin.key
    - administrators using kubectl REST API
- kube-scheduler: scheduler.crt, scheduler.key
    - Looks for Pods that require scheduling
- kube-controller manager: controller-manger.crt, controller-manager.key
    - 
- kube-proxy: kube-proxy.crt, kube-proxy.key
    - 
- kubelet: kubelet-client.crt, kubelet-client.key

- Atleast one Certificate Authority(CA) is required


**Generating a certificate:**

Different tools for generation:

- easyrsa
- openssl
- cfssl

generate key pair for CA
#generate a key
openssl genrsa -out ca.key 2048

#certificate signing request
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr

#Sign the certificate
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
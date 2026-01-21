Namespaces:**

- Logical divisions to separate operations
- Pods can communicate directly only within the same namespace
- `kube-system` is a special namespace created at the time of cluster creation for cluster components such as kube-apiserver, etcd, kube-controller-manager, kube-proxy, coredns
- Namespace scoped objects - pods, deployments, services etc
- Cluster scoped objects - storageclasses, nodes, presistentvolumes etc
- Check if resources are namespace-scoped
	`kubectl api-resources --namespaced=true` -> in a namespace
	`kubectl api-resources --namespaced=false` -> not in a namespace
- When a new cluster is created, the following 4 namespaces are automatically created
	- Default
	- kube-node-lease
	- kube-public
	- kube-system
- Uses:
	- Logical separation: Divide cluster resources between multiple users/teams
	- Resource quotas: Limit resource consumption per namespace
	- Access Control: Apply RBAC policies per namespace
	- Name scoping: Same resource names in different namespaces

```bash

#Create a namespace

kubectl create namespace <namespace-name>

#Get all namespaces

kubectl get namespaces

#Create a resource in a specific namespace

kubectl create -f <resource-file> -n <namespace-name>

#Set default namespace

kubectl config set-context --current --namespace=<namespace-name>

#View current namespace

kubectl config view --minify | grep namespace

```
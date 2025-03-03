#List running pods
kubectl get pods

#List all pods
kubectl get pods --all-namespaces

#See detailed info about pods
kubectl describe pods <pod-name>

#Deploy a pod
kubectl create -f pod-definition.yml
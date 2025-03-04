#List running pods
kubectl get pods

#List all pods
kubectl get pods --all-namespaces

#See detailed info about pods
kubectl describe pods <pod-name>

#Create a pod
kubectl create -f pod-definition.yml

#List all resource types
kubectl get all

#List all services
kubectl get services
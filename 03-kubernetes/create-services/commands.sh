#Create a clusterIP service named my-service that maps port 80 of the service to port 80 of the pod. Use --dry-run=client and -o yaml to output the configuration in YAML format without actually creating the service.
kubectl create service clusterip my-service --tcp=80:80 --dry-run=client -o yaml

#Create a service for an existing deployment named my-deployment. The service should be of type ClusterIP and should map port 80 of the service to port 80 of the pods managed by the deployment. Use --dry-run=client and -o yaml to output the configuration in YAML format without actually creating the service.
kubectl create service clusterip my-service --tcp=80:80 --dry-run=client -o yaml --selector=app=my-deployment
#1. Create a rollout
kubectl create -f deployment-definition.yml

#2. List the rollout
kubectl get deployments

#3. Describe the rollout
kubectl describe deployment myapp-deployment

#4. Scale the rollout
kubectl scale --replicas=6 deployment/myapp-deployment

#5.Check the status of the rollout
kubectl rollout status deployment/myapp-deployment

#6. Update the rollout
kubectl apply -f deployment-definition.yml

#7. Undo a rollout
kubectl rollout undo deployment/myapp-deployment


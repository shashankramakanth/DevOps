#1. Create a replicaset
kubectl create -f replicaset-definition.yml

#2. List the replicaset
kubectl get replicaset

#3. Describe the replicaset
kubectl describe replicaset myapp-replicaset

#4. Scale the replicaset
kubectl scale --replicas=6 -f replicaset-definition.yml #this will not update the replicaset-definition.yml file

#5. Delete a replicaset
kubectl delete replicaset myapp-replicaset

#6. Update the replicaset
kubectl replace -f replicaset-definition.yml

#7. Rollback the replicaset
kubectl rollout undo replicaset myapp-replicaset

#8. Pause the replicaset
kubectl rollout pause replicaset myapp-replicaset

#9. Resume the replicaset
kubectl rollout resume replicaset myapp-replicaset

#10. Check the history of the replicaset
kubectl rollout history replicaset myapp-replicaset

#11. Check the history of the replicaset with revision
kubectl rollout history replicaset myapp-replicaset --revision=2

#12. Edit the replicaset
kubectl edit replicaset myapp-replicaset 
#this will open the file in vi editor
#make the necessary changes and save the file
#this will update the replicaset
#changes are not recommended to be done this way as this reflects immediately and may cause issues

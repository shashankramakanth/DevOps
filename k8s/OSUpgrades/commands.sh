#drain a node
kubectl drain <node-name> --ignore-daemonsets --delete-local-data

#check if the node is drained
kubectl get nodes

#cordon a node
kubectl cordon <node-name>

#check if the node is cordoned
kubectl get nodes #look for the "SchedulingDisabled" status

#uncordon a node
kubectl uncordon <node-name>

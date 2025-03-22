# Add a taint to the node
kubectl taint nodes <node-name> key1=value1:NoSchedule

# Verify the taint is applied
kubectl describe node <node-name> | grep Taints

# Remove the taint
kubectl taint nodes <node-name> key1=value1-


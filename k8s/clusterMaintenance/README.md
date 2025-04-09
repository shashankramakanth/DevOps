OS Upgrades:

- When a node goes down and pods are a part of ReplicaSet, they are recreated.
- Timeout before eviction starts is set in controller manger. Default time is 5m
    
    `kube-controller-manager --pod-eviction-timeout=5m0s`
    
- When the node comes back online, it comes up as blank as all the pods are evicted
- If the pods are not part of a replicaset, they wont be recreated

- A better solution is to drain the node
    
    `kubectl drain <node-name>`
    
- When a node is drained, pods are gracefully terminated and recreated on a different node
- Node is also marked as cordoned or unschedulable
- When a node comes back online, its still unschedulable and need to be uncordoned for the pods to be placed on it
    
    `kubectl uncordon <node-name>`
    
- A node can also be manually marked unschedulable. This will not evict the currently running pods, new pods will not be scheduled on it
    
    `kubectl cordon <node-name>`

**Cluster Upgrade Process:**

- No component can be on a higher version than kube-apiserver
- Controller manager and kube-scheduler can be one version lower than kube-apiserver
- kubelet and kube-proxy can be two versions lower than kube-apiserver
- kubectl utility can be of same version OR one version lower OR one version higher
- kubelet is never upgraded automatically
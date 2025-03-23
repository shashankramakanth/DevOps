- Restrictions and conditions on what pods can be scheduled on a node
- Taints are set on Nodes and Tolerations are set on Pods
    
    ```bash
    kubectl taint nodes <node-name> key=value:taint-effect
    
    #Example
    kubectl taint nodes node1 app=blue:NoSchedule
    ```
    
- Taint effects:
    - NoSchedule - Pods will not be scheduled on the node unless taint is tolerated
    - PreferNoSchedule - System will try to avoid placing a pod on the node
    - NoExecute - Existing pods on the node that don't have matching tolerations will be evicted, and new pods without matching tolerations won't be scheduled evicted
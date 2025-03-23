DaemonSets:

- Similar to ReplicaSets but runs one copy of pod on each node
- When a node is added to the cluster, a pod is automatically created. When a node is removed, the pod is automatically deleted
- Ensures one of the pod is always available on each node
- Use cases:
    - Monitoring Agents
    - Log Collectors
    - kubeproxy, networking - weavenet
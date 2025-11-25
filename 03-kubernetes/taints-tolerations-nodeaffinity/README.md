Taints and Tolerations**

- Taints on nodes and Tolerations on Pods
- Tolerations:
	- Key value pair (eg: gpu=true)
	- Effects:
		- NoSchedule - works only on newer pods
		- noExecute - works on existing and newer pods
		- PreferNoSchedule
- For a pod to be placed to a tainted node, all the taints must match

Lab challenges:
1. Prevent regular workloads on a node
2. Evict all pods from a node
3. Node with multiple taints
4. Graceful eviction with timelimit
5. Daemonset that runs on all the nodes including the ones with taints
---
Node Affinity:

- Set of rules/labels that influences where pods are placed on nodes
- There are 2 properties(types):
	- `requiredDuringSchedulingIgnoredDuringExecution`
	- `preferredDuringSchedulingIgnoredDuringExecution`
- Nodes should be labelled first for nodeAffinity to work
- Only affects scheduling but already executing pods will not be evicted


---
Commands:

- Taint a node
`kubectl taint node node-1 hardware=gpu:NoSchedule`

- Label a node
`kubectl label node node-1 hardware=gpu`

- Untaint a node
`kubectl taint node node-1 hardware=gpu:NoSchedule-`

- Unlabel a node
`kubectl label node node-1 hardware-`
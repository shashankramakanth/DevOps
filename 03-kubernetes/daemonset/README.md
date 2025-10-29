- Get daemonset in default namespace
`kubectl get ds`

- Use nodeselector along with labels to run only of a particular node
```
    spec:
      nodeSelector:
       node-role.kubernetes.io/role: worker
```
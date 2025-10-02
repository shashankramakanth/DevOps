- generate a reference yaml configuration through declarative command

```bash
 kubectl create deployment nginx-deployment --image=nginx:latest --replicas=3 --dry-run=client -o yaml
 ```

- Scale out or scale in replicas

```bash
kubectl scale --replicas=<number> deploy/<deployment-name>
```

- Change the image of a deployment

```bash
kubectl set image deploy/<deployment-name> <nginx=nginx:latest>
```

- Check the changes made to the deployment

```bash
kubectl rollout history deploy/<deployment-name>
```

- Revert latest changes

```bash
kubectl rollout undo deploy/<deployment-name>
```

- Revert to a particular revision

```bash
kubectl rollout undo deployment/<deployment-name> --to-revision=2
```

- Save state of the cluster

```bash
kubectl get all --all-namespaces -o yaml > state.yaml
```
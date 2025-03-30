**Logging and Monitoring:**

**Monitor Cluster Components:**

- Understand node and pod level metrics
- kubelet contains cAdvisor
    - cAdvisor is responsible for retrieving performance metrics from pods and exposing them to the kubelet API to provide metrics

- On minikube run
    
    ```bash
    minikube addons enable metrics-server
    ```
    

- For all other environments, deploy the metrics server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

- View cluster performance
    
    ```bash
    kubectl top node
    
    kubectl top pod
    ```
    

Managing Application logs:

```bash
kubectl logs -f <pod name>
```
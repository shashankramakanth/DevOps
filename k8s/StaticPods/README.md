Static Pods:

- When there is no control-plane or master node, kubelet can still run the pods on a node
- kubelet can be configured to read file from a directory within the node
- Pods which are created by kubelet on its own without the intervention from api-server are known as **static pods**
- Folder is passed in as an option while running the service
    
    ```bash
    #kubelet.service file
    
    --pod-manifest-path=/etc/kubernetes/manifests
    ```
    
- Can also be provided as a config file and define the directory path as static pod path in yaml file
    
    ```bash
    --config=kubeconfig.yaml
    ```
    
    ```yaml
    staticPodPath: /etc/kubernetes/manifests
    ```

    ```bash
    ps -efww | grep -i kubelet #to get config.yaml file path
    ```
    
- kubelet can take inputs from api-server when part of a cluster and also create pods independently
- Even if a pod is created outside of api-server, it is aware of the pod
    - However, metadata will be read-only and pod configuration cannot be changed from api-server
    - configuration must be changed on the node manifest folder
- Use Case:
    - Deploying a control-plane
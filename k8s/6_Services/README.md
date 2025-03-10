NodePort
→ Expose a service to communicate from outside 

→ Helps with internal pod accessible externally through an IP

→ Valid range 30000-32767

There are 3 ports within the service 

1. Port - Service port
2. Target Port - Port of the pod
3. Node port

In yaml file, Port is a mandatory field if Service type: NodePort is specified

- Port - mandatory
- Target Port - Assumed same as port if not specified
- NodePort - Assigned any free port within the range

Use labels to select Pods where ports have to be enabled


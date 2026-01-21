Secrets

- Similar to configmaps but intended to hold confidential data
- Base64 encoded
- can be restricted with RBAC
- encryption at rest - can be enabled in etcd

	Types:
	- opaque - default
	- kubernetes.io/service-account-token
	- kubernetes.io/dockercfg
	- kubernetes.io/dockerconfigjson
	- kubernetes.io/basic-auth
	- kubernetes.io/ssh-auth
	- kubernetes.io/tls

- Creating secrets:
	- Literal values
	- From files
	- TLS secrets
	- Docker registry secret
	- Declarative YAML

###### Best security practices:

- Use RBAC - restrict access to secrets
- Enable encryption at rest
- Use volume mounts
- Limit exposure - dont log or print secrets
- rotate regulary
- use external secret managers



```bash
#Create a tls secret
kubectl create secret tls tls-secret --cert=/root/configmap-lab/tls.crt --key=/root/configmap-lab/tls.key
secret/tls-secret created





```
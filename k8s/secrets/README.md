- Used to manage passwords and secrets which needs to be passed to an app

Creating a secret:

```bash
kubectl create secret generic

kubectl create secret generic 
	<secret-name> --from-literal="<key>=<value>" 

kubectl create secret generic 
	<secret-name> --from-file=<path-to-file>
	
Example:
kubectl create secret generic \
	app-secret --from-literal=DB_HOST=mysql \
						 --from-literal=DB_PASSWORD=passwd \
						 --from_literal=DB_USER=root

kubectl create secret generic 
	<app-secret> --from-file=<app-secret.properties>

OR

kubectl apply -f <secret-definition.yaml>

```


- Secrets are not encrypted but encoded
- Anyone able to create pods/deployments in the same namespace can access secrets
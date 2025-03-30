**ConfigMaps:**

- Used to manage configuration data in key: value format

Creating a configMap:

```bash
kubectl create configmap

kubectl create configmap \
	app-config --from-file=<path-to-file>
	
Example:
kubectl create configmap \
	app-config --from-literal=<key1>=<value1> \
						 --from-literal=<key2>=<value2> \
						 --from-literal=<key3>=<value3>

kubectl create configmap \
	app-config --from-file=app_config.properties

OR

kubectl create -f <definition-file>

Example:
kubectl create -f configmap-definition.yaml
```
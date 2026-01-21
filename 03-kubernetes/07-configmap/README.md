- Stores non-confidential data in key-value pair
- Useful when same values must be used at several places inside a manifest yaml file
- Maximum size of 1MB
- Use cases: environment variables, app configs, command-line arguments, configuration parameters
- this helps overcome the problem of hard coding values

- Can be created from:
	- literal values
	- a file
	- yaml manifest


**Key Concepts**
- `env[].valueFrom.configMapKeyRef`: Single Key mapping
- `envFrom[].configMapRef`: All keys from ConfigMap
- Can combine both methods in same pod
- Environment variable names can be customized


- Imperative command to create a job

```bash
kubectl create job hello-job3 --image=busybox --dry-run=client -o yaml -- sh -c 'echo "Hello from kubernetes job"'
```

- Important fields

    1. `Completions` - Number of successful Pod completions needed(default: 1)
    2. `Parallelism` - Maximum number of Pods running concurrently(default: 1)
    3. `backofflimit` - Number of retries before marking a job as fail(default: 6)
    4. `ttlSecondsAfterFinished` - Automatically delete the job after it finishes

- Restart Policies
    1. `OnFailure`
    2. `Never`
##### Job:
- What is a job?
	- kubernetes controller that runs one or more pods to completion. Short-lived or batch processing workloads, not for long-running services
- Can be configured to run parallely
- What happens to the pods after a job completes sucessfully(or fails)?
	- Pods remain in the cluster however resources are not consumed, only metadata is available in etcd
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

- Restart policy `Always` is not allowed for jobs 

##### Cronjob:
- Cronjob creates jobs on a repeating schedule.
- Kubernetes equivalent of unix cron
- Can be configured to work concurrently
- Keeps a job history
- Use case: backups, reports, cleanup


- Concurrency policy

    - Defines how a cronjob should execute concurrently
    - Values:
    
    1. `Allow` - Default, allows concurrent execution i.e., allows next job to be triggered even if previous job is still running
    2. `Forbid` - Forbids concurrent execution i.e., does not allow next job to be triggered if previous job is still running
    3. `Replace` - Replaces the previous execution if it is still running i.e., kills the previous job and starts a new job



##### Essential commands:

```bash
# Create a job
kubectl create job hello-job3 --image=busybox --dry-run=client -o yaml -- sh -c 'echo "Hello from kubernetes job"'

# Get job
kubectl get jobs

# Describe job
kubectl describe job hello-job3

# Delete job
kubectl delete job hello-job3

# Get job logs
kubectl logs job hello-job3

#Create a cronjob

kubectl create cronjob hello-cronjob --image=busybox --schedule="*/1 * * * *" --dry-run=client -o yaml -- sh -c 'echo "Hello from kubernetes cronjob"'

# Get cronjob
kubectl get cronjobs

# Describe cronjob
kubectl describe cronjob hello-cronjob

# Delete cronjob
kubectl delete cronjob hello-cronjob

# Get cronjob logs
kubectl logs cronjob hello-cronjob

#Suspend a cronjob
kubectl patch cronjob hello-cronjob -p '{"spec":{"suspend":true}}'

#Resume a cronjob
kubectl patch cronjob hello-cronjob -p '{"spec":{"suspend":false}}'

#Manually trigger a cronjob
kubectl create job hello-cronjob-manual --from=cronjob/hello-cronjob

#Wait for a cronjob to finish
kubectl wait --for=condition=complete job/hello-cronjob --timeout=300s

```

##### Tips

1. Do not use `restartPolicy: Always` for jobs(not allowed)
2. Use `backoffLimit` to control the number of retries
3. Use `ttlSecondsAfterFinished` to automatically delete the job after it finishes
4. Use `completions` and `parallelism` to control the number of pods created
5. Use `concurrencyPolicy` to control the number of concurrent executions
6. Specify schedule for a cronjob

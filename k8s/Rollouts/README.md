**Rolling updates and rollbacks:**

Deployment strategies:

- Recreate - Destroy all the running pods and create new pods - requires application downtime
- Rolling update - Pods are taken down one by one and application stays online

- If no strategy is provided, it is assumed as a rolling update

Default history revision limit is 10
This can be specified in .spec.revisionHistoryLimit in deployment yaml file


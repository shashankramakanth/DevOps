Manual Scheduling:

- NodeName field in the yaml file by default is not set. This field is populated by kubernetes
- Scheduler goes through all the pods that are not scheduled and adds this property
- Pod continues to be in Pending state if there is no suitable node
- Node can only be set when a Pod is created; kubernetes doesnt allow nodename modification

Labels and Selectors:

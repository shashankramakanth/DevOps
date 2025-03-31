**Vertical Pod Autoscaler(VPA):**

- Should be installed and configured
- VPA Recommender monitors metrics server → VPA updater takes action → VPA admission controller updates accordingly
- VPA works in 4 modes - specified in UpdateMode field in yaml file:
    - Off mode - Only recommends. Doesnt change anything
    - Initial - Only changes on pod creation. Not later
    - Recreate - Evicts pods if usage goes beyond range
    - Auto - Updates existing pods to recommended numbers. For now, this behaves similar to recreate mode. When support for “In-place update of Pod Resources” is available that mode will be preferred.
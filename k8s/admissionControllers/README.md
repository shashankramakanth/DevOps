**Admission Controllers:**

Few admission controllers

- AlwaysPullImages
- DefaultStorageClass
- EventRateLimit
- NamespaceLifecycle

kubectl → Authentication → Authorization → Admission Controllers → Create Pod

Validating admission controllers

Mutating admission controllers → invoked first to change the request as needed and then passed on to validating admission controller to check if it can be approved

Custom admission controllers can be created by using webhooks

MutatingAdmissionWebhook
ValidatingAdmissionWebhook
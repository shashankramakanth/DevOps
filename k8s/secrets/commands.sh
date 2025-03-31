#encode secret
echo -n "mysecret" | base64

# decode secret
echo "bXlzZWNyZXQ=" | base64 --decode

#list secrets
kubectl get secrets

#describe secret
kubectl describe secret mysecret

#delete secret
kubectl delete secret mysecret


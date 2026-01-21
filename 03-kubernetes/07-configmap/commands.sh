#Create a configmap from literal values
kubectl create configmap db-config --from-literal=DB_HOST=postgres.example.com --from-literal=DB_PORT=5432 --from-literal=DB_NAME=myapp

#Create a configmap from a file
kubectl create configmap app-properties --from-file=app.properties

#Create from a yaml file
kubectl apply -f feature-flags-configmap.yaml

#Create multiple config files
mkdir config
echo "server.port=8080" > config/server.conf
echo "db.url=jdbc:postgresql://db:5432/myapp" > config/db.conf

kubectl create configmap app-config --from-file=config/


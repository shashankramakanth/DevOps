- Create a cluster
kind create cluster --name my-cka-cluster01 --config /Users/shashankramakanth/Documents/GitHub/DevOps/scripts-utils/kind-cluster/config.yaml

- Delete a cluster
kind delete cluster --name my-cka-cluster01

- ssh or exec into a node
docker exec -it my-cka-cluster01-control-plane bash
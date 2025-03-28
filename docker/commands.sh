#run a docker container
docker run -d -p 8080:8080 --name mycontainer <myimage>

#stop a docker container
docker stop <mycontainer>

#remove a docker container
docker rm <mycontainer>

#remove a docker image
docker rmi <myimage>

#list all docker containers (running and stopped)
docker ps -a

#list all docker images
docker images

#list all docker volumes
docker volume ls


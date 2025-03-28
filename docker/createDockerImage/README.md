How to deploy a container and create your own image

Taken from https://github.com/mmumshad/simple-webapp-flask

1. Create Dockerfile
2. Build the file
> docker build . -t my-simple-webapp    

3. Tag it with account name
> docker build . -t <accountname>/<applicationname>

4. Push the image
> docker push <accountname>/<applicationname>
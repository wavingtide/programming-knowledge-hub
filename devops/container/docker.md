# Docker
*(based on [docker documentation](https://docs.docker.com/get-started/overview/) and [microsoft learn](https://learn.microsoft.com/en-us/training/modules/intro-to-docker-containers/))*

Docker provides the ability to package and run an application in a loosely isolated environment called a container. 

Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. This is great for continuous integration and continuous deployment (CI/CD) workflows.

The software packaged into a container includes application code, system packages, binaries, libraries, configuration files, and the operating system.


# Table of Contents
- [Docker](#docker)
- [Table of Contents](#table-of-contents)
- [Docker Architecture](#docker-architecture)
- [Docker Objects](#docker-objects)
- [Underlying technology](#underlying-technology)
- [Installation](#installation)
- [Dockerfile](#dockerfile)
- [Docker Commands](#docker-commands)
  - [`docker build`](#docker-build)
  - [`docker run`](#docker-run)
  - [Remove a Container](#remove-a-container)
  - [List Images](#list-images)
  - [Remove an Image](#remove-an-image)


# Docker Architecture
Docker uses a client-server architecture. The **Docker client** talks to the **Docker daemon**, which does the heavy lifting of building, running, and distributing Docker containers. *Docker daemon* can be local or remote. The client and daemon communicate through **REST API**, over UNIX sockets or a network interface.

Another Docker client is **Docker Compose**, that lets you works with applications consisting a set of containers.

![](https://docs.docker.com/engine/images/architecture.svg)

- The **Docker daemon** (`dockerd`) listens to the Docker API requests and manages Docker objects such as images, containers, networks, and volumes. A daemon can also communicate with other daemons to manage Docker services.

- The **Docker client** (`docker`) is the primary way that the Docker users interact with Docker. The commands sent will be carried out by `dockerd`.

- **Docker Desktop** is an easy-to-install application that includes the Docker daemon (`dockerd`), the Docker client (`docker`), Docker Compose, Docker Content Trust, Kubernetes, and Credential Helper.

- A **Docker Registry** stores and distributes Docker images. [Docker Hub](https://hub.docker.com/) is the default public registry where Docker uses for image management. You can also set up a private registry (eg: Azure container registry). Similar to GitHub, you can `docker pull` and `push` from a docker registry.


# Docker Objects
- An **image** is a read-only template with the instructions for creating a Docker container. You can build your own image by creating a Dockerfile.
  - A **parent image** is a container image from which you create your images (eg: `ubuntu:18.04`, `python-3.8`). We can build an image on top of a parent image.
- A **container** is a runnable instance of an image. It is a sandboxed process that is isolated from all other processes on the host machine. It is also portable and can be run on any OS. You can connect it to network and volume.
- Network
- Volume
- Plugin


# Underlying technology
Docker is written in the Go programming language and takes advantage of several features of the Linux kernel to deliver its functionality. Docker uses a technology called `namespaces` to provide the isolated workspace called the container. When you run a container, Docker creates a set of `namespaces` for that container.

Docker uses Stackable Unification File System (`Unionfs`) when creating Docker images. `Unionfs` is a filesystem that allows you to **stack several directories**, called *branches*, in such a way that it appears as if the content is merged. However, the content is **physically kept separate**. Unionfs allows you to add and remove branches as you build out your file system. A final writeable layer is created once the container is run from the image. This layer however, does not persist when the container is destroyed.

![](https://learn.microsoft.com/en-us/training/modules/intro-to-docker-containers/media/3-unionfs-diagram.svg)


# Installation
Docker website provides the binary file to install Docker Desktop. Visit [Docker Desktop](https://docs.docker.com/desktop/) to get the binary file and follows the installation instruction.

If you are using Linux, you might need some post-installation steps to manage docker as a non-root user. Please refer to [](https://docs.docker.com/engine/install/linux-postinstall/).


# Dockerfile
A **Dockerfile** is a text file that contains the instructions we use to build and run a Docker image.

``` text
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```
Basically, what it does is as follows.
``` text
# Step 1: Specify the parent image for the new image
# Step 2: Configure work directory
# Step 3: Copy code to container
# Step 4: Install requirements
# Step 5: Run the process
# Step 6: Configure network requirements
```

Docker images make use of `unionfs`. Each of these steps creates a cached container image as we build the final container image. These temporary images are layered on top of the previous and presented as single image once all steps complete.


# Docker Commands
We will look at some of the most used commands.

## `docker build`
`docker build` uses a Dockerfile to build a new container.
``` shell
docker build -t getting-started .
```
The `-t` option tags the image, provide a human-readable version name to the image. It is named as `getting-started` in this case. An image can be tagged to multiple tags and is labeled with the latest tag if you don't specify a tag.

The `.` at the end of the command tell Docker to find the `Dockerfile` in the current directory.

The output looks like this
``` shell
Sending build context to Docker daemon  4.69MB
Step 1/8 : FROM ubuntu:18.04
 ---> a2a15febcdf3
Step 2/8 : RUN apt -y update && apt install -y wget nginx software-properties-common apt-transport-https && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && add-apt-repository universe && apt -y update && apt install -y dotnet-sdk-3.0
 ---> Using cache
 ---> feb452bac55a
Step 3/8 : CMD service nginx start
 ---> Using cache
 ---> ce3fd40bd13c
Step 4/8 : COPY ./default /etc/nginx/sites-available/default
 ---> 97ff0c042b03
Step 5/8 : WORKDIR /app
 ---> Running in 883f8dc5dcce
Removing intermediate container 883f8dc5dcce
 ---> 6e36758d40b1
Step 6/8 : COPY ./website/. .
 ---> bfe84cc406a4
Step 7/8 : EXPOSE 80:8080
 ---> Running in b611a87425f2
Removing intermediate container b611a87425f2
 ---> 209b54a9567f
Step 8/8 : ENTRYPOINT ["dotnet", "website.dll"]
 ---> Running in ea2efbc6c375
Removing intermediate container ea2efbc6c375
 ---> f982892ea056
Successfully built f982892ea056
Successfully tagged temp-ubuntu:latest
```

If you want to rebuild the container, you need to remove the existing container.

## `docker run`
Start the container.
``` shell
docker run -dp 3000:3000 getting-started
```
The `-d` option run the container in "detached" mode (mean in the background).

The `-p` option create a mapping from host's port 3000 to the container's port 3000.

If you run it locally, you can open the application that Docker is running at http://localhost:3000/. 

Visiting the Docker Desktop will show the container.
![](https://docs.docker.com/get-started/images/dashboard-two-containers.png)


If you run an image that does not exist locally.
``` shell
docker run -i -t ubuntu /bin/bash
```
When you run the command, the following happens
1. Docker automatically pull it from configured registry (Docker Hub if not set) `docker pull ubuntu` 
2. Docker create a new container `docker container create`
3. Docker allocates a read-write filesystem layers to the container
4. Docker creates network interface connecting the container to the default network, which assign an IP address to the container
5. Docker runs the container and executes `/bin/bash`

## Remove a Container 
1. Use `docker ps` to list the containers
2. Use `docker stop <container-id>` to stop the container
3. After the container is stopped, run `docker rm <container-id>` to remove the container

Else, you can use `docker rm -f <container-id>` to remove the container in one line.

## List Images
``` shell
docker images
```
``` shell
REPOSITORY          TAG                     IMAGE ID            CREATED                     SIZE
tmp-ubuntu          latest             f89469694960        14 minutes ago         1.69GB
tmp-ubuntu          version-1.0        f89469694960        14 minutes ago         1.69GB
ubuntu              18.04                   a2a15febcdf3        5 weeks ago            64.2MB
```

## Remove an Image
Specify the image name or ID in `docker rmi` to remove it.
``` shell
docker rmi temp-ubuntu:version-1.0
```
An error will be raised if the image is in use by a container.


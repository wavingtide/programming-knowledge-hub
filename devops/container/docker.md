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
  - [Build an Image](#build-an-image)
  - [List Images](#list-images)
  - [Remove an Image](#remove-an-image)
  - [Run a Container](#run-a-container)
  - [List Containers](#list-containers)
  - [Pause and Unpause a Container](#pause-and-unpause-a-container)
  - [Restart a Container](#restart-a-container)
  - [Stop a Container](#stop-a-container)
  - [Remove a Container](#remove-a-container)
- [Docker Registry](#docker-registry)
  - [Create an Account](#create-an-account)
  - [Create a Repository](#create-a-repository)
  - [Push the Image](#push-the-image)
  - [See the Logs](#see-the-logs)
- [Storage](#storage)
  - [Volume](#volume)
  - [Bind mount](#bind-mount)
- [Network](#network)
  - [Bridge Network](#bridge-network)
  - [Host Network](#host-network)
  - [none Network](#none-network)
- [Multi-Container Apps](#multi-container-apps)
- [Docker Compose](#docker-compose)
  - [Docker Compose File](#docker-compose-file)
  - [Running the Docker Compose File](#running-the-docker-compose-file)
  - [Check the Logs of Docker Compose Process](#check-the-logs-of-docker-compose-process)
  - [Remove a Docker Compose Process](#remove-a-docker-compose-process)
- [Best Practices](#best-practices)
  - [Security Scanning](#security-scanning)
  - [Layer Inspection](#layer-inspection)
  - [Layer Caching](#layer-caching)
  - [`.dockerignore`](#dockerignore)
  - [Use Mulit-stage Builds](#use-mulit-stage-builds)


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
- Storage
  - Volume
  - Bind mount
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

## Build an Image
`docker build` uses a Dockerfile to build a new container.
``` shell
docker build -t getting-started .
```
The `-t` option tags the image, provide a human-readable version name to the image. It is named as `getting-started` in this case. An image can be tagged to multiple tags and is labeled with the `latest` tag if you don't specify a tag.

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

## List Images
``` shell
docker image ls
```
or
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


## Run a Container
Start the container.
``` shell
docker run -dp 3000:3000 getting-started
```
The `-d` option run the container in "detached" mode (mean in the background).

The `-p` option create a mapping from host's port 3000 to the container's port 3000.

If you run it locally, you can open the application that Docker is running at http://localhost:3000/. 

Visiting the Docker Desktop will show the container.
![](https://docs.docker.com/get-started/images/dashboard-two-containers.png)

Note that the container is assigned a random name. You can specify the name by passing the `--name` option to `docker run`.

You can run multiple containers based on the same image.

If a port is already allocated, the `docker run` will fail. You might want to use a different port or remove the container or process that occupies the port.

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

## List Containers
``` shell
docker ps -a
```
``` shell
CONTAINER ID    IMAGE        COMMAND         CREATED       STATUS           PORTS        NAMES
d93d40cc1ce9    tmp-ubuntu:latest  "dotnet website.dll …"  6 seconds ago    Up 5 seconds        8080/tcp      happy_wilbur
33a6cf71f7c1    tmp-ubuntu:latest  "dotnet website.dll …"  2 hours ago     Exited (0) 9 seconds ago            adoring_borg
```

## Pause and Unpause a Container
``` shell
docker pause <container-id/name>
```
``` shell
docker unpause <container-id/name>
```

## Restart a Container
``` shell
docker restart <container-id/name>
```

## Stop a Container
``` shell
docker stop <container-id/name>
```

## Remove a Container 
You need to stop the container before removing it.
``` shell
docker rm <container-id/name>
``` 

Else, you can use `docker rm -f <container-id/name>` to remove the container in one line.


# Docker Registry
## Create an Account
To use [Docker Hub](https://hub.docker.com/), you need to have an account.

To login to your account, run
``` shell
docker login -u <YOUR-USER-NAME>
```

## Create a Repository
On the Docker Hub website, you can click the **Create Repository** button to create a repository.

![](https://i.imgur.com/Us6Oagx.png)

## Push the Image
If you use the docker commands specified in Docker Hub repository page, it will show an error.
``` shell
$ docker push wavetitan/getting-started
 The push refers to repository [docker.io/wavetitan/getting-started]
 An image does not exist locally with the tag: wavetitan/getting-started
```

As shown by the error message, the image with tag `wavetitan/getting-started` does not exist locally. You need to tag your image to have the same tag as the remote tag.
``` shell
docker tag getting-started wavetitan/getting-started
```

After that, a `docker push` will be successful
``` shell
docker push wavetitan/getting-started
```

## See the Logs
``` shell
$ docker logs -f <container-id>
nodemon src/index.js
[nodemon] 2.0.20
[nodemon] to restart at any time, enter `rs`
[nodemon] watching dir(s): *.*
[nodemon] starting `node src/index.js`
Using sqlite database at /etc/todos/todo.db
Listening on port 3000
```

Using `Ctrl + C` to quit watching the logs.


# Storage
Container storage is temporary. To persist the data between different container, you can make use of volumes or bind mount.

## Volume
A **volume** connects specific filesystem paths of the container back to the host machine. If a directory in the container is mounted, changes in that directory are also seen on the host machine.

You can use `docker volume create` command to create new volume. Else, Docker will create the volume if it doesn't exist when you try to mount the volume into a container the first time.
``` shell
docker volume create todo-db
```

Attach the volume mount when doing `docker run`.
``` shell
docker run -dp 3000:3000 --mount type=volume,src=todo-db,target=/etc/todos getting-started
```

You can think of a volume mount as an opaque bucket of data. If you want to know more details about the volume, you can inspect it.
``` shell
$ docker volume inspect todo-db
[
    {
        "CreatedAt": "2019-09-26T02:18:36Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/todo-db/_data",
        "Name": "todo-db",
        "Options": {},
        "Scope": "local"
    }
]
```

Multiple containers can simultaneously use the same volume mount. Volume mount also don't get removed automatically when a container stops using the volume.

## Bind mount
A **bind mount** is conceptually the same as a volume, however, instead of using a specific folder of the containers, you can mount any file or folder on the host. You're also expecting the host can change the contents of these mounts. Just like volumes, the bind mount is created if you mount it, and it doesn't yet exist on the host.

To use bind mount, use the `--mount type=bind,src=<host machine path>,target=<container path>` to `docker run`
``` shell
docker run -it --mount type=bind,src="$(pwd)",target=/src ubuntu bash
```

Using bind mounts is common for local development setups. The advantage is that the development machine doesn’t need to have all of the build tools and environments installed.

An example usage of bind mount is to mount the source code into the container. As soon as you save a change, the container will see it.

Bind mounts have limited functionality compared to volumes, and even though they're more performant, they depend on the host having a specific folder structure in place.

Volumes are considered the preferred data storage strategy to use with containers.


# Network
**Network** allows you to build and configure apps that can communicate securely with each other.

Docker provides three pre-configured network configurations:
- Bridge
- Host
- none

## Bridge Network
The Bridge network configuration is an internal, private network used by the container, and isolates the container network from the Docker host network. 

Each container in the bridge network is assigned an IP address and subnet mask with the hostname defaulting to the container name. Containers connected to the default bridge network are allowed to access other bridge connected containers by IP address. The bridge network doesn't allow communication between containers using hostnames.

By default, Docker doesn't publish any container ports. To enable port mapping between the container ports and the Docker host ports, use the Docker port --publish flag.

The publish flag effectively configures a firewall rule that maps the ports.

In this example, your tracking portal is accessible to clients browsing to port 80. You'll have to map port 80 from the container to an available port on the host. You have port 8080 open on the host, which enables you to set the flag like this.

``` shell
--publish 8080:80
```

## Host Network
The **host network** enables you to run the container on the host network directly. This configuration effectively removes the isolation between the host and the container at a network level. Using the host network configuration isn't supported for both Windows and macOS desktops.

## none Network
The **none network** is used to disable networking for containers.


# Multi-Container Apps
In general, each container should do one thing and do it well. This allows you to decouple the applications such as database and application code.

You can use **networking** to allow containers to talk to each other. If two containers are on the same network, they can talk to each other. If they aren’t, they can’t.

Create a network
``` shell
docker network create todo-app
```

Attach the network when running `docker run`
``` shell
docker run -d \
     --network todo-app --network-alias mysql \
     -v todo-mysql-data:/var/lib/mysql \
     -e MYSQL_ROOT_PASSWORD=secret \
     -e MYSQL_DATABASE=todos \
     mysql:8.0
```

# Docker Compose
**Docker Compose** is a tool that was developed to help define and share multi-container applications. Docker Compose allows creating a YAML file to define the services and with a single command, can spin everything up or tear it all down.

## Docker Compose File
You can use a `docker-compose.yml` file to define the application stack, instead of running them using a number of commands.

If you are a Linux user and you install docker engine instead of Docker Desktop, you might need to install docker compose.

Example of `docker-compose.yml` file
``` yaml
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 3000:3000
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos

  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-mysql-data:
```

You always start the `docker-compose.yml` file with `service:` and specify the service name (in this case `app` and `mysql`). After that, you configure the options for the image (such as ports, working directory, environment variable)

You also need to define the volume in the top-level `volumes:` section and then specify the mountpoint in the service config.

By default, Docker Compose automatically creates a network specifically for the application stack.

## Running the Docker Compose File
``` shell
docker compose up -d
```
The output will be like this
``` shell
Creating network "app_default" with the default driver
Creating volume "app_todo-mysql-data" with default driver
Creating app_app_1   ... done
Creating app_mysql_1 ... done
```

## Check the Logs of Docker Compose Process
``` shell
docker compose logs -f
```
To follow a specific service.
``` shell
docker compose logs -f <service>
```

## Remove a Docker Compose Process
``` shell
docker compose down
```
By default, the volume is not removed. To remove the volume too, run
``` shell
docker compose down --volume
```


# Best Practices
## Security Scanning
Docker partners with Synk to provide the vulnerability scanning services. The scan uses a constantly updated database of vulnerabilities.

To use it, you must be logged in to Docker Hub. You can do so by `docker scan --login`

To scan your images, run
``` shell
docker scan <image-name>
```
The output will look something like this.
``` shell
✗ Low severity vulnerability found in freetype/freetype
  Description: CVE-2020-15999
  Info: https://snyk.io/vuln/SNYK-ALPINE310-FREETYPE-1019641
  Introduced through: freetype/freetype@2.10.0-r0, gd/libgd@2.2.5-r2
  From: freetype/freetype@2.10.0-r0
  From: gd/libgd@2.2.5-r2 > freetype/freetype@2.10.0-r0
  Fixed in: 2.10.0-r1

✗ Medium severity vulnerability found in libxml2/libxml2
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-ALPINE310-LIBXML2-674791
  Introduced through: libxml2/libxml2@2.9.9-r3, libxslt/libxslt@1.1.33-r3, nginx-module-xslt/nginx-module-xslt@1.17.9-r1
  From: libxml2/libxml2@2.9.9-r3
  From: libxslt/libxslt@1.1.33-r3 > libxml2/libxml2@2.9.9-r3
  From: nginx-module-xslt/nginx-module-xslt@1.17.9-r1 > libxml2/libxml2@2.9.9-r3
  Fixed in: 2.9.9-r4
```
You can also [configure Docker Hub](https://docs.docker.com/docker-hub/vulnerability-scanning/) to scan all newly pushed images automatically,

## Layer Inspection
You can inspect each layer of the images by running
``` shell
docker image history <image-name>
```
The output will look something like this.
``` shell
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
 a78a40cbf866        18 seconds ago      /bin/sh -c #(nop)  CMD ["node" "src/index.j…    0B                  
 f1d1808565d6        19 seconds ago      /bin/sh -c yarn install --production            85.4MB              
 a2c054d14948        36 seconds ago      /bin/sh -c #(nop) COPY dir:5dc710ad87c789593…   198kB               
 9577ae713121        37 seconds ago      /bin/sh -c #(nop) WORKDIR /app                  0B                  
 b95baba1cfdb        13 days ago         /bin/sh -c #(nop)  CMD ["node"]                 0B                  
 <missing>           13 days ago         /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B                  
 <missing>           13 days ago         /bin/sh -c #(nop) COPY file:238737301d473041…   116B                
 <missing>           13 days ago         /bin/sh -c apk add --no-cache --virtual .bui…   5.35MB              
 <missing>           13 days ago         /bin/sh -c #(nop)  ENV YARN_VERSION=1.21.1      0B                  
 <missing>           13 days ago         /bin/sh -c addgroup -g 1000 node     && addu…   74.3MB              
 <missing>           13 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=12.14.1     0B                  
 <missing>           13 days ago         /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B                  
 <missing>           13 days ago         /bin/sh -c #(nop) ADD file:e69d441d729412d24…   5.59MB
```

Use `--no-trunc` to show a not truncated output.
``` shell
docker image history --no-trunc getting-started
```

## Layer Caching
An important thing to know to help decreasing build times for the container images.
```
Once a layer changes, all downstream layers have to be recreated as well
```

We can intentionally organize the Dockerfile to reduce the recreated layer to reduce the build time.

One common way is to put the dependency installation at the top of `Dockerfile` to cache the dependencies, as it is less likely to change as compared to the source code.

Original `Dockerfile`
``` shell
FROM
Learn more about the "FROM" Dockerfile command.
 node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

Improved `Dockerfile`
``` shell
 FROM node:18-alpine
 WORKDIR /app
 COPY package.json yarn.lock ./
 RUN yarn install --production
 COPY . .
 CMD ["node", "src/index.js"]
```

If the dependencies don't change in the subsequent build, Docker will use the cached layers and you will notice that the build is much faster.

## `.dockerignore`
Docker CLI will exclude files and directories that match patterns in it, before sending them to the docker daemon. This helps to avoid unnecessarily sending large or sensitive files and directories to the daemon.

For the purposes of matching, the root of the context is considered to be both the working and the root directory.

Example:
``` text
# comment
*/temp*
*/*/temp*
temp?
```

## Use Mulit-stage Builds
Benefits of using multi-stage build
- Separate build-time dependencies from runtime dependencies
- Reduce overall image size by shipping only what your app needs to run

For example, when we are using a compiled language like Java, the compiler and package manager isn't needed in production

``` shell
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps
```

In the first part, we use one stage to perform the Java build. In the second stage, we copy in files from the build stage. The final image is the last stage created. (can be overridden using `--target` option)

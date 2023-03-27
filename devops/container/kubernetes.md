# Kubernetes
*(refer to [official documentation](https://kubernetes.io/))*


# Table of Contents
- [Kubernetes](#kubernetes)
- [Table of Contents](#table-of-contents)
- [Components](#components)
- [`kubectl`](#kubectl)
  - [Installation](#installation)
- [`minikube`](#minikube)
  - [Installation](#installation-1)


# Components
![](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

- Cluster
- Node
  - kubelet
  - kube-proxy
  - Container runtime
- Pod
- Control panel
  - kube-apiserver
  - etcd
  - kube-scheduler
  - kube-controller-manager
  - cloud-controller-manager

# `kubectl`
The Kubernetes command-line tool, `kubectl` allows you to run commands against Kubernetes cluster.

## Installation
**Installation with Linux**

Download the latest release with the command
``` shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
Install kubectl
``` shell
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

For ubuntu, one can use the `apt` package manager to install.
``` shell
sudo apt update
sudo apt-get install -y ca-certificates curl
```
Download the public signing key.
``` shell
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```
Add the kubernetes `apt` repository
``` shell
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
Update `apt` package index and install `kubectl`.
``` shell
sudo apt-get update
sudo apt-get install -y kubectl
```

# `minikube`
*(refer to [official documentation](https://minikube.sigs.k8s.io/docs/start/))*
minikube is local Kubernetes.

## Installation
**For Linux**
``` shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

``` shell
minikube start
```
![](https://i.imgur.com/3sk6A7y.png)


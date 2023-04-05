# gcloud
*(refer to [official documentation](https://cloud.google.com/cli))*


# Table of Contents
- [gcloud](#gcloud)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Linux](#linux)
  - [MacOS](#macos)
- [Initilization](#initilization)
- [Basic Command](#basic-command)
- [Google Compute Engine](#google-compute-engine)


# Installation
*(refer to [official documentation](https://cloud.google.com/sdk/docs/install))*
## Linux
Prerequisite
``` shell
sudo apt-get install apt-transport-https ca-certificates gnupg
```

Add the gcloud CLI distribution URI as a package source.
``` shell
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

Import the Google Cloud public key.
``` shell
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
```

Update and install the gcloud CLI
``` shell
sudo apt-get update && sudo apt-get install google-cloud-cli
```

## MacOS
1. Download the package from [official website](https://cloud.google.com/sdk/docs/install#mac).
2. Run `./google-cloud-sdk/install.sh`

![](https://i.imgur.com/woKMwdl.png)

The different components of gcloud.
``` shell
┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   Components                                                   │
├───────────────┬──────────────────────────────────────────────────────┬──────────────────────────────┬──────────┤
│     Status    │                         Name                         │              ID              │   Size   │
├───────────────┼──────────────────────────────────────────────────────┼──────────────────────────────┼──────────┤
│ Not Installed │ App Engine Go Extensions                             │ app-engine-go                │  4.2 MiB │
│ Not Installed │ Appctl                                               │ appctl                       │ 18.5 MiB │
│ Not Installed │ Artifact Registry Go Module Package Helper           │ package-go-module            │  < 1 MiB │
│ Not Installed │ Cloud Bigtable Command Line Tool                     │ cbt                          │  9.8 MiB │
│ Not Installed │ Cloud Bigtable Emulator                              │ bigtable                     │  6.3 MiB │
│ Not Installed │ Cloud Datastore Emulator                             │ cloud-datastore-emulator     │ 35.1 MiB │
│ Not Installed │ Cloud Firestore Emulator                             │ cloud-firestore-emulator     │ 41.6 MiB │
│ Not Installed │ Cloud Pub/Sub Emulator                               │ pubsub-emulator              │ 66.4 MiB │
│ Not Installed │ Cloud Run Proxy                                      │ cloud-run-proxy              │  7.4 MiB │
│ Not Installed │ Cloud SQL Proxy                                      │ cloud_sql_proxy              │  7.3 MiB │
│ Not Installed │ Google Container Registry's Docker credential helper │ docker-credential-gcr        │          │
│ Not Installed │ Kustomize                                            │ kustomize                    │  7.4 MiB │
│ Not Installed │ Log Streaming                                        │ log-streaming                │ 11.9 MiB │
│ Not Installed │ Minikube                                             │ minikube                     │ 31.3 MiB │
│ Not Installed │ Nomos CLI                                            │ nomos                        │ 24.6 MiB │
│ Not Installed │ On-Demand Scanning API extraction helper             │ local-extract                │ 11.9 MiB │
│ Not Installed │ Skaffold                                             │ skaffold                     │ 21.7 MiB │
│ Not Installed │ Terraform Tools                                      │ terraform-tools              │ 59.6 MiB │
│ Not Installed │ anthos-auth                                          │ anthos-auth                  │ 19.2 MiB │
│ Not Installed │ config-connector                                     │ config-connector             │ 55.6 MiB │
│ Not Installed │ enterprise-certificate-proxy                         │ enterprise-certificate-proxy │  6.1 MiB │
│ Not Installed │ gcloud Alpha Commands                                │ alpha                        │  < 1 MiB │
│ Not Installed │ gcloud Beta Commands                                 │ beta                         │  < 1 MiB │
│ Not Installed │ gcloud app Java Extensions                           │ app-engine-java              │ 64.6 MiB │
│ Not Installed │ gcloud app PHP Extensions                            │ app-engine-php               │ 21.9 MiB │
│ Not Installed │ gcloud app Python Extensions                         │ app-engine-python            │  8.4 MiB │
│ Not Installed │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras     │ 26.4 MiB │
│ Not Installed │ gke-gcloud-auth-plugin                               │ gke-gcloud-auth-plugin       │  7.2 MiB │
│ Not Installed │ kpt                                                  │ kpt                          │ 20.7 MiB │
│ Not Installed │ kubectl                                              │ kubectl                      │  < 1 MiB │
│ Not Installed │ kubectl-oidc                                         │ kubectl-oidc                 │ 19.2 MiB │
│ Not Installed │ pkg                                                  │ pkg                          │          │
│ Installed     │ BigQuery Command Line Tool                           │ bq                           │  1.6 MiB │
│ Installed     │ Cloud Storage Command Line Tool                      │ gsutil                       │ 15.5 MiB │
│ Installed     │ Google Cloud CLI Core Libraries                      │ core                         │ 20.1 MiB │
│ Installed     │ Google Cloud CRC32C Hash Tool                        │ gcloud-crc32c                │  1.2 MiB │
└───────────────┴──────────────────────────────────────────────────────┴──────────────────────────────┴──────────┘
```

To install or remove components, run
``` shell
gcloud components install COMPONENT_ID
gcloud components remove COMPONENT_ID
```

To update SDK installation version, run
``` shell
gcloud components update
```


# Initilization
Run
``` shell
gcloud init
```

![](https://i.imgur.com/Adttcos.png)
![](https://i.imgur.com/IyY5zBt.png)

To get authenticated, run
``` shell
gcloud auth application-default login
```

![](https://i.imgur.com/m4EGxjs.png)


# Basic Command
List all the configuration
``` shell
gcloud config list
```
![](https://i.imgur.com/mKxTXBR.png)

Change a config
``` shell
gcloud config set project PROJECT_ID
gcloud config set compute/zone ZONE_NAME
```

List all authentication
``` shell
gcloud auth list
```

List all available projects
``` shell
gcloud projects list
```


# Google Compute Engine
List all available VM
``` shell
gcloud compute instances list
```

Set up the SSH
``` shell
gcloud compute ssh <instance-name>
```
This will automatically generate the SSH key and propagate to the instance if it is not yet exist.

Be default, it will use the setting in your gcloud config. You might need to specify more information if the setting didn't match.
``` shell
gcloud compute ssh --project=<project-id> --zone=<zone> <instance-name>
```

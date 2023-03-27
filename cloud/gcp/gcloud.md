# gcloud
*(refer to [official documentation](https://cloud.google.com/cli))*


# Table of Contents
- [gcloud](#gcloud)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Initilization](#initilization)


# Installation
*(refer to [official documentation](https://cloud.google.com/sdk/docs/install))*

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

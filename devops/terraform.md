# Terraform
*(refer to [developer hashicorp](https://developer.hashicorp.com/terraform) and [registry hashicorp](https://registry.terraform.io/))*

Terraform is an infrastructure as code tool that lets you build, change and version infrastructure safely and efficiently.


# Table of Contents
- [Terraform](#terraform)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)


# Installation
*(refer to [official documentation](https://developer.hashicorp.com/terraform/downloads))*

For Ubuntu/Debian, run
``` shell
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```


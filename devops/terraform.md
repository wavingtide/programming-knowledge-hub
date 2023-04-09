# Terraform
*(refer to [developer hashicorp](https://developer.hashicorp.com/terraform) and [registry hashicorp](https://registry.terraform.io/))*

Terraform is an infrastructure as code tool that lets you build, change and version infrastructure safely and efficiently.


# Table of Contents
- [Terraform](#terraform)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Miscellaneous](#miscellaneous)
- [Core Workflow](#core-workflow)
- [Quick Start](#quick-start)


# Installation
*(refer to [official documentation](https://developer.hashicorp.com/terraform/downloads))*

For Ubuntu/Debian, run
``` shell
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Miscellaneous
Terraform has a version manager called [tfenv](https://github.com/tfutils/tfenv).

To install it in mac, you can use homebrew
``` shell
brew install tfenv
```

To install it in Linux, you can run 
``` shell
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
```
Add it to PATH.
``` shell
echo 'export PATH=$PATH:$HOME/.tfenv/bin' >> ~/.bashrc
```

Usage
``` shell
tfenv install latest
```


# Core Workflow
- Write - Define infrastructure in configuration file
- Plan - Review the changes Terraform will make to your infrastructure
- Apply - Terraform provisions your infrastructure and update the static file


# Quick Start
Create a `main.tf` file
``` terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```

Add environment variable
``` shell
export AWS_ACCESS_KEY_ID=
```
``` shell
export AWS_SECRET_ACCESS_KEY=
```

Initializing terraform
``` shell
terraform init
```
![](https://i.imgur.com/5Rbtolu.png)

Check formatting
``` shell
terraform fmt
```

See the plan
``` shell
terraform plan
```

Apple the configuration
``` shell
terraform apply
```

It can be helpful to save the plan into a file and apply it from the file.
``` shell
terraform plan -out tf.plan
```
``` shell
terraform apply "tf.plan"
```

To remove the resource.
``` shell
terraform destroy
```

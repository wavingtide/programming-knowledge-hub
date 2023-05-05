# Terraform
*(refer to [developer hashicorp](https://developer.hashicorp.com/terraform) and [registry hashicorp](https://registry.terraform.io/))*

Terraform is an infrastructure as code tool that lets you build, change and version infrastructure safely and efficiently.


# Table of Contents
- [Terraform](#terraform)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [`tfenv`](#tfenv)
- [Core Workflow](#core-workflow)
- [Quick Start](#quick-start)
- [Terraform Language](#terraform-language)
- [State](#state)
  - [Backend](#backend)
  - [Workspace](#workspace)
- [Modules](#modules)
  - [`module` block](#module-block)
  - [Meta-Arguments](#meta-arguments)


# Installation
*(refer to [official documentation](https://developer.hashicorp.com/terraform/downloads))*

For Ubuntu/Debian, run
``` shell
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

## `tfenv`
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
This will create a `.terraform/` folder and `.terraform.lock.hcl` file in your current folder.

Check formatting
``` shell
terraform fmt
```
![](https://i.imgur.com/7jMSBLm.png)

See the plan
``` shell
terraform plan
```

Apply the configuration
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

# Terraform Language
``` terraform
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

Example
- `<BLOCK TYPE>` - `variable`, `provider`, `resource`, `data`
- `<BLOCK LABEL>` - `aws_s3_bucket`, `google_cloud_run_service`, `databricks_notebook`


# State
State is the status of the managed infrastructure and configuration. By default, it is stored in a local file called `terraform.tfstate`. 

Terraform uses state to determine which changes to make to your infrastructure. Prior to any operation, Terraform does a refresh to update the state with real infrastructure.

## Backend
Backend are responsible for storing state and providing an API for state locking.

## Workspace
Terraform starts with a single workspace called `default`.

The current workspace can be used using `${teraform.workspace}`.

Use case: a common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure to test a set of changes before modifying production infrastructure

Workspace is not suitable if the organizations want to create a strong separation between multiple deployments of the same infrastructure serving different development stages or different internal teams, which each deployment often has different credentials and access controls

List the workspace
``` shell
$ terraform workspace list

* default
```

To create a workspace
``` shell
terraform workspace new <name>
```
This will create a folder `terraform.tfstate.d` if it doesn't already exist. Each workspace will be a separate subfolder.

To delete a workspace
``` shell
terraform workspace delete <name>
```

To switch to another workspace
``` shell
terraform workspace select <name>
```

To show the current workspace
``` shell
terraform workspace show
```

Terraform workspace can be referred as a variable `${terraform.workspace}` when writing `.tf` file
``` terraform
locals {
  instance_name = "${terraform.workspace}-instance" 
}
```

# Modules
A module is a container for multiple resources that are used together. A module consists of a collection of `.tf` and/or `.tf.json` files kept together in a directory.

- *Root module* - Resources defined in `.tf` files in the main working directory. Every terraform configuration has root module
- *Child module* - A module that called by another module
- *Published module* - Module from public or private registry

[Terraform Registry](https://registry.terraform.io/browse/modules) hosts a broad collection of publicly available Terraform modules for configurating many kinds of common infrastructure.

Terraform Cloud and Terraform Enterprise both include a private module registry for sharing modules internally within your organization.

## `module` block
Modules are called from within other modules using `module` block.

Using local module
``` terraform
module "server" {
  source = "./app_cluster"

  server = 5
}
```

Using module from a module registry
``` terraform
module "consul" {
  source = "hashicorp/consul/aws"
  version = ">= 0.0.5, < 0.1.0"
}
```
The label following the block name `module` is the local name of the module. For the argument
- `source` argument is mandatory for all modules
- `version` argument is recommended for modules from registry
- Terraform have other meta-arguments such as `for_each` and `depends_on`
- Other input variables for the modules

After adding, removing, or modifying `module` blocks, you must re-run `terraform init` for Terraform to adjust the installed modules. `-upgrade` option can be used to upgrade moduke to the latest available version.

## Meta-Arguments
Along with `source` and `version`, Terraform defines a few more optional meta-arguments
- `count`
- `for_each`
- `providers`
- `depends_on`

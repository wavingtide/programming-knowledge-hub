# Terraform
*(refer to [developer hashicorp](https://developer.hashicorp.com/terraform) and [registry hashicorp](https://registry.terraform.io/))*

Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share.


# Table of Contents
- [Terraform](#terraform)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [`tfenv`](#tfenv)
- [Quick Start](#quick-start)
- [Core Workflow](#core-workflow)
- [Concept](#concept)
- [Generated File/Folders](#generated-filefolders)
- [Terraform Language](#terraform-language)
  - [Meta-Arguments](#meta-arguments)
- [Data Source](#data-source)
- [Provider](#provider)
- [State](#state)
  - [Backend](#backend)
  - [Workspace](#workspace)
- [Modules](#modules)
  - [`module` block](#module-block)
  - [Meta-Arguments](#meta-arguments-1)
  - [Standard Module Structure](#standard-module-structure)


# Installation
*(refer to [official documentation](https://developer.hashicorp.com/terraform/downloads))*

For Ubuntu/Debian, run
``` shell
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

For mac
Install the HashiCorp tap
``` shell
brew tap hashicorp/tap
```
Install Terraform
``` shell
brew install hashicorp/tap/terraform
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


# Quick Start
1. Install CLI and define environment variable
   - AWS
   Create AWS account, install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), create a credential in AWS
      ``` shell
      export AWS_ACCESS_KEY_ID=<aws-access-key-id>
      ```
      ``` shell
      export AWS_SECRET_ACCESS_KEY=<aws-secret-access-key>
      ```
   - GCP
   Create GCP account, create GCP project, enable Google Compute Engine and create a service account with role 'Editor', create the service account key
      ``` shell

      ```
   - Azure
   Create Azure account, install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli). Authenticate using the Azure CLI
      ``` shell
      az login
      ```
      Set subcription
      ``` shell
      az account set --subscription "35akss-subscription-id"
      ```
      Create service principal
      ``` shell
      az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
      ```
      Set environment variables
      ``` shell
       export ARM_CLIENT_ID="<APPID_VALUE>"
       export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
       export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
       export ARM_TENANT_ID="<TENANT_VALUE>"
      ```
2. Create a `main.tf` file in the project repository
   - AWS
      ``` terraform
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
   - GCP
      ``` terraform
      provider "google" {
        credentials = file("<NAME>.json")

        project = "<PROJECT_ID>"
        region  = "us-central1"
        zone    = "us-central1-c"
      }

      resource "google_compute_network" "vpc_network" {
        name = "terraform-network"
      }
      ```
   - Azure
      ``` terraform
      provider "azurerm" {
        features {}
      }

      resource "azurerm_resource_group" "rg" {
        name     = "myTFResourceGroup"
        location = "westus2"
      }
      ```

3. Initializing terraform
``` shell
terraform init
```
![](https://i.imgur.com/5Rbtolu.png)
This will create a `.terraform/` folder and `.terraform.lock.hcl` file in your current folder.

4. Check formatting
``` shell
terraform fmt
```
If there is formatting problem, an error will be raised
![](https://i.imgur.com/7jMSBLm.png)

5. See the plan
``` shell
terraform plan
```

6. Apply the configuration
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


# Core Workflow
- **Write** - Author infrastructure as code
- **Plan** - Preview changes before applying
- **Apply** - Provision reproducible infrastructure


# Concept
- Resource - Infrastructure object
- Resource block - Describe one or more infrastructure objects
- Module
- State
- Provider - A plugin for Terraform that offers a collection of resource types


# Generated File/Folders
Files containing Terraform code are often called *configuration files*.

When running `terraform init`
- `.terraform.lock.hcl` - dependency lock file which tracks the provider dependencies
  - Terraform will re-select the version in lock file if it exists, use `terraform init -upgrade` to override the behavior


# Terraform Language
The main purpose of the Terraform language is declaring resources, which represent infrastructure object.

``` terraform
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

Example
- `<BLOCK TYPE>` - `resource`, `variable`, `provider`, `data`
- `<BLOCK LABEL>` - `aws_s3_bucket`, `google_cloud_run_service`, `databricks_notebook`

Every Terraform provider has its own [documentation](https://registry.terraform.io/search/providers?namespace=hashicorp), describing its resource type and their arguments.

## Meta-Arguments
| Meta-arguments | Description | Remark |
| -- | -- | -- |
| `depends_on` | handle hidden resource or module dependencies that Terraform cannot automatically infer |  |
| `count` | accept a whole number, and create that many instances of the resource or module | <li> Attribute: `count.index` </li> <li> A resource is identified by an index number, e.g. `aws_instance.server[0]` </li> |
| `for_each` | accepts a map or a set of strings, and creates an instance for each item in that map or set | <li> Attribute: `each.key`, `each.value` (same as `each.key` when a set is provided) </li> <li> A resource is identified by key, e.g. `azurerm_resource_group.rg["a_group"]` </li> |
| `provider` | selecting a non-default provider configuration | Accepted format: `<PROVIDER>.<ALIAS>` |
| `lifecycle` | lifecycle customization | <li> Argument available: `create_before_destroy`, `prevent_destroy`, `ignore_changes`, and `replace_triggered_by` </li> <li>You can add `precondition` and `postcondition` block with a `lifecycle` block to specify assumptions and guarantees about how resources and data sources operate </li> |
| `provisioner` | taking extra actions after resource creation | Should only be used as last resort because Terraform cannot model the actions of provisioners as part of a plan because they can in principle take any action |

- Meta argument `count`
  ``` terraform
  resource "aws_instance" "server" {
    count = 4 # create four similar EC2 instances

    ami           = "ami-a1b2c3d4"
    instance_type = "t2.micro"

    tags = {
      Name = "Server ${count.index}"
    }
  }
  ```
- Meta argument `for_each`

  - Map
    ``` terraform
    resource "azurerm_resource_group" "rg" {
      for_each = {
        a_group = "eastus"
        another_group = "westus2"
      }
      name     = each.key
      location = each.value
    }
    ```
  - Set
    ``` terraform
    resource "aws_iam_user" "the-accounts" {
      for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
      name     = each.key
    }
    ```
- Meta argument `provider`
  ``` terraform
  # default configuration
  provider "google" {
    region = "us-central1"
  }

  # alternate configuration, whose alias is "europe"
  provider "google" {
    alias  = "europe"
    region = "europe-west1"
  }

  resource "google_compute_instance" "example" {
    # This "provider" meta-argument selects the google provider
    # configuration whose alias is "europe", rather than the
    # default configuration.
    provider = google.europe

    # ...
  }
  ```
- Meta argument `lifecycle`
  ``` terraform
  resource "azurerm_resource_group" "example" {
    # ...

    lifecycle {
      create_before_destroy = true
    }
  }
  ```
  - Using `precondition`
  ``` terraform
  resource "aws_instance" "example" {
    instance_type = "t2.micro"
    ami           = "ami-abc123"

    lifecycle {
      # The AMI ID must refer to an AMI that contains an operating system
      # for the `x86_64` architecture.
      precondition {
        condition     = data.aws_ami.example.architecture == "x86_64"
        error_message = "The selected AMI must be for the x86_64 architecture."
      }
    }
  }
  ```
- Meta argument `provisioner`
  ``` terraform
  resource "aws_instance" "web" {
    # ...

    provisioner "local-exec" {
      command = "echo The server's IP address is ${self.private_ip}"
      on_failure = continue
    }
  }
  ```


# Data Source
Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

Each providers may offer data sources alongside its set of resource types. (e.g. AWS EC2 has data source `aws_ami`, Google Compute Engine has data source `google_compute_address`).

``` terraform
data "aws_ami" "example" {
  most_recent = true

  owners = ["self"]
  tags = {
    Name   = "app-server"
    Tested = "true"
  }
}
```

Each data instance will export one or more attributes, which can be used in other resources as reference expressions of the form `data.<TYPE>.<NAME>.<ATTRIBUTE>`

Data sources are essentially a read only subset of resources, they can use meta-arguments including `count`, `for_each`, `provider`, `depends_on`. `lifecycle` is not available but reserved for future versions.

Setting the `depends_on` meta-argument within `data` blocks defers reading of the data source until after all changes to the dependencies have been applied. Terrafrom do not recommend using `depends_on` with data resources.

Data instance arguments may refer to computed values, in which case the attributes of the instance itself cannot be resolved until all of its arguments are defined. In this case, refreshing the data instance will be deferred until the "apply" phase, and all interpolations of the data instance attributes will show as "computed" in the plan since the values are not yet known.

# Provider
Providers allow Terraform to interact with cloud providers, SaaS providers, and other APIs.
``` terraform
provider "google" {
  project = "acme-app"
  region  = "us-central1"
}
```

# State
State is the status of the managed infrastructure and configuration, which acts as a source of truth for your environment. By default, it is stored in a local file called `terraform.tfstate`. 

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

Terraform evaluates all of the configuration files in a module, effectively treating the entire module as a single document.

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
  - Local path
  - Terraform registry
  - Version control platform such as GitHub, Bitbucket
  - HTTP URLs
  - S3 bucket, GCS buckets
- `version` argument is recommended for modules from registry
- Terraform have other meta-arguments such as `for_each` and `depends_on`
- Other input variables for the modules

After adding, removing, or modifying `module` blocks, you must re-run `terraform init` for Terraform to adjust the installed modules. `-upgrade` option can be used to upgrade moduke to the latest available version.

## Meta-Arguments
Along with `source` and `version`, Terraform defines a few more optional meta-arguments
- `count` - accept a whole number, and create that many instances of the resource or module. Expression `count.index` can be used to modify the configuration of each object.
  - To refer to single object, one can use index to refers to individual instances
- `for_each` - accepts a map or a set of strings, and creates an instance for each item in that map or set
- `providers` - specify which provider configurations from the parent module will be available inside the child module
- `depends_on` - handle hidden resource or module dependencies that Terraform cannot automatically infer

## Standard Module Structure
``` shell
module
├── README.md
├── main.tf
├── variables.tf
└── outputs.tf
```

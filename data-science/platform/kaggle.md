# Kaggle
*(based on [kaggle](https://www.kaggle.com))*

Kaggle is an online community of data scientist and machine learning practitioners. Kaggle provides competitions, notebooks, datasets.

Kaggle also provides free access to NVIDIA TESLA P100 GPUs and TPU.

![](https://i.imgur.com/6dCASv1.png)

# Table of Contents
- [Kaggle](#kaggle)
- [Table of Contents](#table-of-contents)
- [Kaggle Progression System](#kaggle-progression-system)
- [Competitions](#competitions)
  - [Competition Types](#competition-types)
  - [Competition Formats](#competition-formats)
- [Kaggle CLI](#kaggle-cli)
  - [Installation](#installation)
  - [Authentication](#authentication)
  - [Usage](#usage)
    - [Competitions](#competitions-1)
    - [Datasets](#datasets)
    - [Notebooks](#notebooks)


# Kaggle Progression System
Kaggle has a progression system which uses performance tiers to track the user's growth as a data scientist. The *Progression System* is designed around four categories of data science expertise: **Competitions**, **Notebooks**, **Datasets** and **Discussion**. Advancement through performance tiers is done independently within each category of expertise.

The five performance tiers are **Novice**, **Contributor**, **Expert**, **Master**, and **Grandmaster**.

Points in Kaggle are designed to decay over time to keep Kaggle's rankings contemporary and competitive.

For more details, check out [kaggle progression system](https://www.kaggle.com/progression).

The ranking can be found [here](https://www.kaggle.com/rankings).

# Competitions
## Competition Types
- Featured
- Research - more experimental
- Getting started
- Playground
- Recruitment
- Annual - March Machine Learning Competition, Santa-themed optimization competition

## Competition Formats
- Simple competitions - submit prediction in specified format (e.g. [safe drive prediciton](https://www.kaggle.com/c/porto-seguro-safe-driver-prediction))
- Two-stage competitions - competition with stage 1 and 2, where stage 2 building on the result achieved in stage 1 (e.g. [fishing monitoring competition](https://www.kaggle.com/c/the-nature-conservancy-fisheries-monitoring))
- Code competitions - submit Kaggle notebooks (e.g. [Quora insincere questions classification](https://www.kaggle.com/c/quora-insincere-questions-classification))


# Kaggle CLI
The Kaggle API and CLI tools provide easy ways to interact with Competitions, Datasets and Notebooks on Kaggle.

## Installation
``` shell
pip install kaggle
```

## Authentication
To use the Kaggle's public API, one must first authenticated using an API token.

Click Profile Picture --> `Settings`. Under `API`, click `Create New Token`. This will automatically download a `kaggle.json` file.

Store the `kaggle.json` file in location `~/.kaggle/kaggle.json` to use the Kaggle API.

If the `kaggle.json` does not exist at the right location, it will return an error.
![](https://i.imgur.com/XzKur8j.png)

## Usage
One can always append `-h` after any call to see the help menu for that command.

For more information, check out [official documentation](https://github.com/Kaggle/kaggle-api)

### Competitions
- `kaggle competitions list` - list the currently active competitions
- `kaggle competitions download -c [COMPETITION]` - download files associated with a competition
- `kaggle competitions submit -c [COMPETITION] -f [FILE] -m [MESSAGE]` - make a competition submission
- `kaggle competitions submissions -c [COMPETITION]` - list all previous submissions to a competition you have entered

### Datasets
- `kaggle datasets list -s [KEYWORD]` - list datasets matching a search term
- `kaggle datasets download -d [DATASET]` - download files associated with a dataset
- `kaggle datasets init -p /path/to/dataset` - generate a metadata file `dataset-metadata.json` in the dataset folder
  ``` json
    {
        "title": "INSERT_TITLE_HERE",
        "id": "username/INSERT_SLUG_HERE",
        "licenses": [
            {
            "name": "CC0-1.0"
            }
        ]
    }
  ```
- `kaggle datasets create -p /path/to/dataset` - create the dataset (run after adding the metadata), use `-u` to make the dataset public

** Kaggle recommends using [Frictionless Data’s Data Package Creator](http://create.frictionlessdata.io/) to update the metadata

### Notebooks
- `kaggle kernels list -s [KEYWORD]` - list notebooks matching a search term
- `kaggle kernels push -k [KERNEL] -p /path/to/kernel` - create and run a notebook on Kaggle
- `kaggle kernels pull [KERNEL] -p /path/to/download -m` - download code files and metadata associated with a notebook
- `kaggle kernels init -p /path/to/kernel` - generate a metadata file
  ``` json
  # note that notebook titles and slugs are linked to each other
  # a notebook slug is always the title lowercased with dashes (-) replacing spaces and removing special characters
  {
    "id": "wavingtide/INSERT_KERNEL_SLUG_HERE",
    "title": "INSERT_TITLE_HERE",
    "code_file": "INSERT_CODE_FILE_PATH_HERE",
    "language": "Pick one of: {python,r,rmarkdown}",
    "kernel_type": "Pick one of: {script,notebook}",
    "is_private": "true",
    "enable_gpu": "false",
    "enable_internet": "true",
    "dataset_sources": [],
    "competition_sources": [],
    "kernel_sources": [],
    "model_sources": []
  }
  ```
- `kaggle kernels push -p /path/to/kernel` - create and run notebook on kaggle
- `kaggle kernels pull [KERNEL] -p /path/to/download -m` - download notebook's most recent code and metadata files


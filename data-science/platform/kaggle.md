# Kaggle
*(based on [kaggle](https://www.kaggle.com))*

Kaggle is an online community of data scientist and machine learning practitioners.

![](https://i.imgur.com/6dCASv1.png)

# Table of Contents
- [Kaggle](#kaggle)
- [Table of Contents](#table-of-contents)
- [Kaggle CLI](#kaggle-cli)
  - [Installation](#installation)
  - [Authentication](#authentication)
  - [Usage](#usage)



Kaggle has a progression system which uses performance tiers to track the user's growth as a data scientist. The *Progression System* is designed around four categories of data science expertise: **Competitions**, **Notebooks**, **Datasets** and **Discussion**. Advancement through performance tiers is done independently within each category of expertise.

The five performance tiers are **Novice**, **Contributor**, **Expert**, **Master**, and **Grandmaster**.

Points in Kaggle are designed to decay over time to keep Kaggle's rankings contemporary and competitive.

For more details, check out [kaggle progression system](https://www.kaggle.com/progression).

The ranking can be found [here](https://www.kaggle.com/rankings).

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
List the currently active competitions
``` shell
kaggle competitions list
```



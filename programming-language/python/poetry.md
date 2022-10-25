# Poetry 
(based on version 1.2)

# Table of Contents
- [Poetry](#poetry)
- [Table of Contents](#table-of-contents)
- [Additional File](#additional-file)
- [Installation](#installation)
  - [Method 1: Using the official installer](#method-1-using-the-official-installer)
    - [Linux/Mac/WSL](#linuxmacwsl)
    - [Windows](#windows)
  - [Method 2: Using pipx](#method-2-using-pipx)
  - [Method 3: Manual Installation](#method-3-manual-installation)
  - [Advanced Installation](#advanced-installation)
  - [Test Installation](#test-installation)
  - [Update Poetry](#update-poetry)
  - [Enable auto-completion](#enable-auto-completion)
- [Basic usage](#basic-usage)
  - [Create a new Poetry project](#create-a-new-poetry-project)
  - [Initializing a Pre-Existing Project](#initializing-a-pre-existing-project)
  - [Add dependency](#add-dependency)

Poetry is a tool for **dependency management** and **packaging** in Python. It allows you to declare the libraries your project depends on and it will manage (install/update) them for you. Poetry offers a lockfile to ensure repeatable installs, and can build your project for distribution.

**Requirements**: Python 3.7+

# Additional File
- pyproject.toml
- poetry.lock (can think of it as requirements.txt)

# Installation 
Refer to [link](https://python-poetry.org/docs/#installing-with-the-official-installer).

## Method 1: Using the official installer
Available at https://install.python-poetry.org/ and is developed in [its github repository](https://github.com/python-poetry/install.python-poetry.org).

### Linux/Mac/WSL
``` bash
curl -sSL https://install.python-poetry.org | python3 -
```

### Windows
``` bash
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -
```

After the installation, you might need to add the folder to the path. 

![](https://i.imgur.com/0t7fBD4.png)

## Method 2: Using pipx
``` bash
pipx install poetry
```

## Method 3: Manual Installation
``` bash
python3 -m venv $VENV_PATH
$VENV_PATH/bin/pip install -U pip setuptools
$VENV_PATH/bin/pip install poetry
```

## Advanced Installation
For more advanced installations (eg: set installed location, set version), plesae refer to  [link](https://python-poetry.org/docs/#installing-with-the-official-installer).


## Test Installation
``` bash
poetry --version
```

## Update Poetry
``` bash
poetry self update
```

``` bash
pipx upgrade poetry
```

## Enable auto-completion
Allow auto completion of poetry related command in bash shell.
``` bash
poetry completions bash >> ~/.bash_completion
```
This command will add some scripts to the file `~/.bash_completion`.

For other shell (eg: zsh, fish), please refer to the official [link](https://python-poetry.org/docs/#installing-with-the-official-installer).

Older version (<1.2) put the script at different locations.

# Basic usage

## Create a new Poetry project

``` bash
poetry new poetry-playground
```

This will create a `poetry-playground` with the following structure.
```
poetry-playground
├── README.md
├── poetry_playground
│   └── __init__.py
├── pyproject.toml
└── tests
    └── __init__.py
```

`pyproject.toml` orchestrate the project and its dependencies. Content of `pyproject.toml`:
```
[tool.poetry]
name = "poetry-playground"
version = "0.1.0"
description = ""
authors = ["wavetitan <wavetitango@gmail.com>"]
readme = "README.md"
packages = [{include = "poetry_playground"}]

[tool.poetry.dependencies]
python = "^3.8"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

## Initializing a Pre-Existing Project
This will create a `pyproject.toml` file based on your input. It will not generate the package and test folder.
``` bash
mkdir poetry-playground2
cd poetry-playground2
poetry init
```
![](https://i.imgur.com/fybsUHc.png)

## Add dependency
Run in command line.
``` 
poetry add pandas
```

Or manually add it in `pyproject.toml`.
```
[tool.poetry.dependencies]
pandas = "^1.5.1"
```


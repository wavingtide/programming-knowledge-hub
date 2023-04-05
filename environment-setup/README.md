# Environment Setup

# Directory
Set up the evironments for different OS.
.  
├── [linux](linux/)  
│    ├── [README.md](linux/README.md)  
│    └── [ubuntu](linux/ubuntu/)  
│         └── [ubuntu_setup.sh](linux/ubuntu_setup.sh)  
├── [mac](mac/)  
│    ├── [mac_setup.md](mac/mac_setup.md)  
│    └── [mac_setup.sh](mac/mac_setup.sh)  
├── [virtual-machine](virtual-machine/)  
│    └── [hyper_v.md](virtual-machine/hyper_v.md)  
└── [windows](windows/)  
      └── [windows_setup.md](windows/windows_setup.md)  


# Table of Contents
- [Environment Setup](#environment-setup)
- [Directory](#directory)
- [Table of Contents](#table-of-contents)
- [Installation through UI](#installation-through-ui)
- [IDE](#ide)
- [Programming-Related](#programming-related)
  - [General](#general)
  - [Python related](#python-related)
  - [Cloud](#cloud)
  - [Javascript](#javascript)
  - [Devops](#devops)
  - [Ruby](#ruby)
  - [Golang](#golang)
  - [Rust](#rust)
  - [Java](#java)
- [Platform Set Up](#platform-set-up)
  - [Connect to Github through SSH](#connect-to-github-through-ssh)
- [Terminal Set Up](#terminal-set-up)
- [Optional](#optional)



# Installation through UI
That might be setups that should be done through the UI.
- Browser ([Mozilla Firefox](https://www.mozilla.org/en-US/firefox/new/), [Google Chrome](https://www.google.com/chrome/), [Microsoft Edge](https://www.microsoft.com/en-us/edge/download/), [Brave](https://brave.com/download/))
- [WhatsApp](https://www.whatsapp.com/download)
- [Telegram](https://desktop.telegram.org/)
- Sign in to [Microsoft Office Suite](https://www.office.com/) and install Microsoft Office
- [Bitwarden](https://bitwarden.com/download/) as **password manager**
- [Notion](https://www.notion.so/desktop)
- [Slack](https://slack.com/downloads/windows)
- [Discord](https://discord.com/download)


# IDE
- [Pycharm](https://www.jetbrains.com/pycharm/download/#section=windows)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/download/other.html)
- [VS Code](https://code.visualstudio.com/download)
  - Open editor commands (`Ctrl + Shift + P`) and run `Install 'code' command in PATH`
  - Install additional extensions
    - Appearance
      - Shades of Purple
      - Material Icon Theme
    - Coding language
      - Python
      - C/C++
    - Formatter
      - Prettier - Code formatter
    - Web Dev
      - Auto Rename Tag
      - Live Server
    - Markdown
      - Markdown All in One
      - markdownlint
    - Devops
      - Docker
      - YAML
      - Ansible
      - HashiCorp Terraform
    - Text editor
      - VIM
  - Download the font Cascadia Code from [its release](https://github.com/microsoft/cascadia-code/releases) and install all the fonts
  - Update `settings.json`
    ``` shell
    {
        "files.exclude": {
            "**/__pycache__": true
        },
        "workbench.iconTheme": "material-icon-theme",
        "workbench.colorTheme": "Shades of Purple (Super Dark)",
        "editor.fontFamily": "Cascadia Code",
        "editor.fontLigatures": true,
        "editor.wordWrap": "on",
        "emmet.includeLanguages": {
            "javascript": "javascriptreact"
        },
        "terminal.integrated.fontSize": 14,
        "files.autoSave":"afterDelay",
        "editor.formatOnSave": true,
        "editor.fontSize": 14,
        "terminal.integrated.fontFamily": "MesloLGS NF"
    }
    ```


# Programming-Related
## General
- [Postman](https://www.postman.com/downloads/)
- [Compass](https://www.mongodb.com/products/compass)
- [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim), you can get the release file from their [Github release](https://github.com/neovim/neovim/releases). For Windows, search for `nvim-win64.msi`, download and run it.
  ``` shell
  # for macbook
  brew install neovim
  ```
  Set up Neovim using [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
  ``` shell
  mkdir -p ~/.config/nvim
  cd ~/.config/nvim
  nvim init.lua
  ```
  And copy the content from `init.lua` from the Github repo to the file. Next time, when you run `nvim`, it will complete the set up.
  ![](https://i.imgur.com/F3xidu1.png)

## Python related
- Python (other installation might have installed it)
- [MiniConda](https://docs.conda.io/en/latest/miniconda.html)
  - Run `conda config --set auto_activate_base false` to stop `base` environment to be activated by default
- [pyenv](https://github.com/pyenv/pyenv)
  ``` shell
  # for macbook
  brew install pyenv
  ```
  And run the following if you are using zsh
  ``` shell
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  ```
- [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
  ``` shell
  # for macos
  brew install pyenv-virtualenv
  ```
  You can create an environment as follows
  ``` shell
  pyenv virtualenv 3.8.10 my-virtual-env-2.7.10
  ```
- [pipx](https://github.com/pypa/pipx)
  ``` shell
  # macos
  brew install pipx
  pipx ensurepath

  # linux
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
  ```

## Cloud
- [gcloud](https://cloud.google.com/sdk/docs/install)
  - Install in `$HOME`, after that, run `./google-cloud-sdk/install.sh` to set it up


## Javascript
- [nvm](https://github.com/nvm-sh/nvm)
  ``` shell
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  ```
- [Node.js](https://nodejs.org/en)
  ``` shell
  nvm install --lts
  ```

## Devops
- [Docker](https://docs.docker.com/get-docker/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [tfenv](https://github.com/tfutils/tfenv)
  ``` shell
  tfenv install latest
  tfenv use 1.4.4
  terraform -install-autocomplete
  ```

## Ruby
- [rbenv](https://github.com/rbenv/rbenv#installation)
  ``` shell
  # mac
  brew install rbenv ruby-build

  # debian-based
  sudo apt install rbenv
  ```
  Depends on your shell, you might need slight different commands.
  ``` shell
  echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc
  ```

## Golang
Download the release from [Go website](https://go.dev/dl/) and run it.


## Rust
Follow the instructions from [rust website](https://www.rust-lang.org/tools/install)
``` shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
![](https://i.imgur.com/mH5DCFD.png)

Download the following extensions for VS Code
- rust-analyzer
- CodeLLDB
- crates

## Java
Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) and run it.

# Platform Set Up
## Connect to Github through SSH
1. Generate a new SSH key
   ``` shell
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
2. Start a SSH agent
   ``` shell
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
3. Run `touch ~/.ssh/config` and `nano ~/.ssh/config` to configurate the ssh configuration, add the following. If you are using passphrase, add `UseKeychain yes`
   ``` shell
   Host github.com
     AddKeysToAgent yes
     IdentityFile ~/.ssh/id_ed25519
   ```
4. Add the SSH private key to the ssh-agent. Add option `--apple-use-keychain` if you are using passphrase
   ``` shell
   ssh-add ~/.ssh/id_ed25519
   ```
5. Copy the key
   ``` shell
   pbcopy < ~/.ssh/id_ed25519.pub
   ```
6. Go to Github `Settings -> SSH and GPG keys`, click *New SSH key* and paste the key
7. Run `ssh -T git@github.com` to test the connection


# Terminal Set Up
- tree
  ``` shell
  # macos
  brew install tree

  # linux
  sudo apt install tree
- [exa](https://github.com/ogham/exa) - better version of `ls`
  ``` shell
  brew install exa
  ```
  ![](https://i.imgur.com/DDWaaK9.png)
  You can also append the following to `~/.zshrc` if you want to replace `ls` completely
  ``` shell
  if [ -x "$(command -v exa)" ]; then
      alias ls="exa"
      alias la="exa --long --all --group"
  fi
  ```


If you are using Oh my zsh, you can download
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)

``` shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
Add the plugins to `/.zshrc`
``` text
plugins=( 
    # other plugins...
    zsh-autosuggestions,
    zsh-syntax-highlighting
)
```


# Optional
- Obsidian

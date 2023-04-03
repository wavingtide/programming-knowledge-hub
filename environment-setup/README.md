# Environment Setup

Set up the evironments for different OS.

.  
├── [linux](linux/)  
│    └── [README.md](linux/README.md)  
│    └── [ubuntu](linux/ubuntu/)  
│         └── [ubuntu_setup.sh](linux/ubuntu_setup.sh)  
├── [mac](mac/)  
│    └── [mac_setup.sh](mac/mac_setup.sh)  
├── [virtual-machine](virtual-machine/)  
│    └── [hyper_v.md](virtual-machine/hyper_v.md)  
└── [windows](windows/)  
      ├── [windows_setup.md](windows/windows_setup.md)  
      └── [windows_setup.sh](windows/windows_setup.sh)


That might be setups that should be done through the UI.
- Browser ([Mozilla Firefox](https://www.mozilla.org/en-US/firefox/new/), [Google Chrome](https://www.google.com/chrome/), [Microsoft Edge](https://www.microsoft.com/en-us/edge/download/), [Brave](https://brave.com/download/))
- [WhatsApp](https://www.whatsapp.com/download)
- [Telegram](https://desktop.telegram.org/)
- Sign in to [Microsoft Office Suite](https://www.office.com/) and install Microsoft Office
- [Bitwarden](https://bitwarden.com/download/) as **password manager**
- [Notion](https://www.notion.so/desktop)
- [Slack](https://slack.com/downloads/windows)
- [Pycharm](https://www.jetbrains.com/pycharm/download/#section=windows)
- [Discord](https://discord.com/download)
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
        "editor.fontSize": 14
    }
    ```
- [Docker](https://docs.docker.com/get-docker/)
- [Postman](https://www.postman.com/downloads/)
- [Compass](https://www.mongodb.com/products/compass)
- [MiniConda](https://docs.conda.io/en/latest/miniconda.html)
  - Run `conda config --set auto_activate_base false` to stop `base` environment to be activated by default

Some tools can be installed through shell script.
- [nvm](https://github.com/nvm-sh/nvm)
  ``` shell
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  ```
- [Node.js](https://nodejs.org/en)
  ``` shell
  nvm install --lts
  ```
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
- Python


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


Optional
- Obsidian





# GitHub
*(based on [GitHub Docs](https://docs.github.com/en))*

GitHub is the most popular version control system (VCS) platform which almost every developers use. Therefore, it will be rewarding to learn beyond the basic.

# Github Components to Know
- Repository
- Package
- Issues
- Projects
- Labels and Milestones
- Pull Requests
- Security
- GitHub Actions
- Bot

# GitHub CLI
`gh` is GitHub on the command line.

## Installation
Mac
``` shell
brew install gh
```

Debian/Ubuntu
``` shell
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

Windows
``` shell
winget install --id GitHub.cli
```

## Usage
Login
``` shell
gh auth login
```







# Issues
Use GitHub **Issues** to track ideas, feedback, tasks, or bugs for work in Github.

# Labels and milestones

# Tasklist


# Pull Requests


# Projects
A **project** is an adaptable spreadsheet that integrates with your issues and pull requests on GitHub to help you **plan and track your work** effectively. 


# Organizations
## Team


# Bot

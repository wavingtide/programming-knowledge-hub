# MacOS Setup

Steps to set up a MacBook for programming usage.


# Table of Contents
- [MacOS Setup](#macos-setup)
- [Table of Contents](#table-of-contents)
- [Set Up Finder](#set-up-finder)
- [Settings](#settings)
  - [Appearance](#appearance)
  - [Customize Spotlight](#customize-spotlight)
  - [Configure security](#configure-security)
  - [Other Settings](#other-settings)
- [Programming](#programming)
  - [Install Xcode Command Line Tools](#install-xcode-command-line-tools)
  - [Install HomeBrew](#install-homebrew)
  - [Install iTerm2](#install-iterm2)
  - [Install Oh My Zsh](#install-oh-my-zsh)
  - [Connect to Github through SSH](#connect-to-github-through-ssh)
- [Other Applications](#other-applications)



Follow the steps in [environment-setup](../README.md)

# Set Up Finder
- Go to *View*, click *Show Path Bar* and *Show Status Bar*
- Create a folder called "Code" or "Developer" in the user folder
- Go to *Finder -> Settings*, for *New Finder windows show*, choose your username.
  - Uncheck the option *Open folders in abs instead of new windows*
  - Go to *Sidebar* and uncheck *Recents* and *AirDrop*, check your username
  - Go to *Advanced*, for *When performing a search*, choose *Search the Current Folder*
- Also, drag the "Code" folder to sidebar

# Settings
## Appearance
- Go to *Appearance*, choose *Dark Mode* for Appearance, choose *Small* for Sidebar icon size
- Go to *Desktop & Dock*, decrease the size and increase magnification, uncheck *Show recent applications in Dock* and check *Minimise windows into application icon*. 
  - Scroll down to *Windows & Apps* and turn on *Stage Manager*, customize and uncheck *Recent applications*
  - Scroll down to *Mission Control*, check *Group windows by application*
- Go to *Displays*, select *More Space*, uncheck *Automatically adjust brightness*
  - Click *Night Shift...* and set *Colour temperature* as much as you want.
- Go to *Control Centre*, select *Show in Menu Bar* for *Bluetooth*
  - Scroll down to *Battery* and check *Show Percentage*
- Right click on the desktop, go to *Show View Options*, select *Snap to Grid* for *Sort By*
  - Right click on the desktop, choose *Use Stacks*
- Remove redundant apps from Dock

## Customize Spotlight
Go to *Siri & Spotlight*, uncheck *Contacts*, *Events & Reminders*, *Mail & Messages*, *Siri Suggestions*

## Configure security
*(This is based on Macbook Air with M2 chip and MacOS Venture 13.3, different MacOS version might store the settings at different places, you can always use Spotlight Search to find what you want)*
- Create another admin user account (in case the primary account get hacked)
- Safari
  - Go to *Safari -> Settings... -> General*, uncheck the option *Open "safe" files after downloading* 
  - Go to *Safari -> Settings... -> Search*, unchek *Include Safari Suggestions* and *Preload Top Hit in the background*
- Go to *Network -> Firewall*, enable firewall
- Go to *Privacy -> Advanced...*, enable *Require an administrator password to access systemwide settings*
- Go to *Privacy & Security -> Analytic & Improvements* and ensure that all the options are unchecked
- Go to *Privacy & Security*, turn on *FileVault*

## Other Settings
- Can go to *Trackpad* increase tracking speed
- Can go to *Accessibility* and check *Use scroll gesture with modifier keys to zoom* (allow you to zoom any screen with control and 2 fingers on trackpad)


# Programming
## Install Xcode Command Line Tools
Xcode Command Line Tools are tools for software developer that run on the command line. Run the following and a pop up will appear for you to complete the installation.
``` shell
xcode-select --install
```

You can run other common command line for developer such as `git`, `gcc`, `clang` to trigger the installation. The following message will be shown. 
``` shell
xcode-select: note: No developer tools were found, requesting install.
If developer tools are located at a non-default location on disk, use sudo xcode-select --switch path/to/Xcode.app to specify the Xcode that you wish to use for command line developer tools, and cancel the installation dialog.
See man xcode-select for more details.
```

The installation will take a few minutes.

If you are developing software for Apple device, you might need the full XCode Application.


## Install HomeBrew
Follow the instruction on `https://brew.sh/` to install HomeBrew
``` shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the instruction on the output to add brew to the path.
``` shell
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/weiti/.zprofile
```
``` shell
eval "$(/opt/homebrew/bin/brew shellenv)"
```


## Install iTerm2
iTerms is a replacement for Terminal. Download the zipped file from [iTerm2](https://iterm2.com/) and run it.

Settings to change
- Go to *General -> Closing*, remove *Confirm "Quit iTerm2"*

Additional settings
- Go to *Profiles -> General*, add personal profile and check *Reuse previous session's directory*
- Go to *Profiles -> Window*, add Transparency and Blur
- Go to *Profiles -> Colors*, change background color (e.g. Solaris Dark)


## Install Oh My Zsh
[Oh my Zsh](https://ohmyz.sh/) is a framework for managing Zsh configuration.
``` shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the theme [PowerLevel10k](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
``` shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Change the `.zshrc` file `ZSH_THEME` from `robbyrussell` to `powerlevel10k/powerlevel10k`

To make the changes appear, quit iTerm2 and restart it. It will prompt you to download the `Meslo Nerd Font` and start the configuration.

Example Configuration:
- Prompt Style: Rainbow
- Character: Unicode
- Show Time: 24-hour format
- Prompt Separator: Slanted
- Prompt Head: Sharp
- Prompt Tail: Flat
- Prompt Height: Two lines
- Prompt Connection: Disconnected
- Prompt Frame: Left
- Frame Color: Light
- Prompt Spacing: Sparse
- Icons: Many icons
- Prompt Flow: Fluent
- Enable Transient Prompt: Yes
- Instant Prompt Mode: Verbose

The result is store in `~/.p10k.zsh`. You can configure the settings directly from the file. One configuration is to uncomment RAM to add it to the right prompt.

If you are unhappy with the configuration or want to change the nerd font, you can run
``` shell
p10k configure
```

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


# Other Applications
- [Clean My Mac](https://cleanmymac.com/)
- Paste - Clipboard Manager
- iStat Menus (cost $14.98) - see the stat of the laptop
- [Alfred](https://www.alfredapp.com/) - more powerful spotlight
- [Rectangle](https://rectangleapp.com/) - move and resize windows using keyboard shortcuts

# pipx

Refer to [official documentation](https://pypa.github.io/pipx/).

*Based on my interpretation, `pipx` is basically `pip` but it isolates the installation and add it to `PATH`, so the package can be used globally. It is suitable for installing Command Line Interface (CLI) packages that should be available globally, such as `black` or `poetry`. It also comes with some additional functions, such as `pipx reinstall all`.*

Based on the [official documentation](https://pypa.github.io/pipx/), `pipx` enables you to
- Expose CLI entrypoints of packages ("apps") installed to isolated environments with the `install` command. This guarantees no dependency conflicts and clean uninstalls!
- Easily list, upgrade, and uninstall packages that were installed with pipx
- Run the latest version of a Python application in a temporary environment with the `run` command

# Table of Contents
- [pipx](#pipx)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [On Mac](#on-mac)
  - [On Linux](#on-linux)
  - [On Windows](#on-windows)
- [Shell Completions](#shell-completions)
- [Installation](#installation-1)
- [List Programs](#list-programs)
- [Run Programs Without Installing](#run-programs-without-installing)
- [Recommended Program](#recommended-program)
- [Further Reading (Documentation)](#further-reading-documentation)


# Installation
## On Mac
``` bash
brew install pipx
pipx ensurepath
```
Upgrade pipx with `brew update && brew upgrade pipx`

## On Linux
``` bash
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```
![](https://i.imgur.com/7ufj85T.png)
Upgrade pipx with `python3 -m pip install --user -U pipx`

## On Windows
Run
``` bash
python -m pip install --user pipx
```
![](https://i.imgur.com/76V4UMo.png)


``` bash
 cd .\AppData\Roaming\Python\Python310\Scripts\
.\pipx ensurepath
```
![](https://i.imgur.com/WnmVUXE.png)
You needs to restart the terminal for the PATH changes to take effect. If it does not work, you might need to add to the `PATH` manually using Powershell.

# Shell Completions
``` bash
pipx completions
```
![](https://i.imgur.com/8bPeCTW.png)

# Installation
``` bash
pipx install PACKAGE
```
The command creates a **virtual environment**, installs the **package** and adds the associated applications (entry points) to a location on your **`PATH`**. Therefore, the library is available globally but sandbox in its own environment.

Example:
``` bash
pipx install black --verbose
```
![](https://i.imgur.com/eWxiaWU.png)

# List Programs
``` bash
pipx list
```

# Run Programs Without Installing
``` bash
pipx run pycowsay moooo!
```
``` bash
pipx run black file.py
```

# Recommended Program
https://pypa.github.io/pipx/programs-to-try/

# Further Reading (Documentation)
For more advanced usage such as specifying `pip` options, configuration options or accesing development versions, please check the official documentation.
- [Commands](https://pypa.github.io/pipx/docs/)
- [Example](https://pypa.github.io/pipx/examples/)
- [How pipx works](https://pypa.github.io/pipx/how-pipx-works/)
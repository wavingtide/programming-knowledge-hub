# Windows Setup

# Chocolatey
[Chocolatey](https://chocolatey.org/install#individual) is an established package manager for Windows.

Run powershell as admin
``` powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

# CMake
Cmake manages the build process in an operating system and in a compiler-independent manner. It can be downloaded from [CMake download page](https://cmake.org/download/).


# Microsoft C++ Build Tools
This can be installed through the installer of [Visual Studio](https://aka.ms/vs/17/release/vs_buildtools.exehttps://visualstudio.microsoft.com/downloads/). When installing, only check the *Windoes 11 SDK* option.

# MSYS2
MSYS2 is a collections of tools and libraries providing you with an easy-to-use environment for building, installing and running native Window software.

Install the Mingw-w64 toolchain by running the following in MSYS2 terminal.
``` shell
pacman -S --needed base-devel mingw-w64-x86_64-toolchain
```
Press enter to install everything
![](https://i.imgur.com/T57hZLh.png)

Add `C:\msys64\mingw64\bin` to the PATH

# Windows Subsystem for Linux (WSL)
Run powershell as administrator
``` shell
wsl --install
```

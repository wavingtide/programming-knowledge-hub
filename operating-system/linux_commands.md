# Most Basic Linux Commands

## apt
### apt update && apt upgrade
Update and upgrade packages
``` bash
sudo apt update && sudo apt upgrade -y
```
### apt install
``` bash
sudo apt install software-properties-common
```
### apt remove
``` bash
sudo apt remove code
```

### cat
Print the content of a file
``` bash
cat filename.txt
```

### cd
Change directory
``` bash
cd dir_path
```

### chmod
Change the access permissions and special mode flags of file system objects.  
Three sets of permission:
- user permissions: Owner of the file
- group permissions: Members of the file group
- other permissions: Everyone else

Permissions
- r: Read permissions.
- w: Write permissions.
- x: Execute permissions.
``` bash
# add execute permission to everyone
chmod +x new_script.sh
```
``` bash
# Set read and write permission to user, read permission to group and other
chmod u=rw,og=r new_file.txt
```

### echo
Repeat what you tell it to repeat
``` bash
echo This is a message
```
``` bash
# Output
This is a message
```

### export
Set environment variable in shell.
Example: Add a new directory to the PATH environment variable.
``` bash
export PATH="/bin/myscripts:$PATH"
```

One can add the above line in rc file (eg: `~/.bashrc`) to make the environment variable permanent.
``` bash
echo 'export PATH="/bin/myscripts:$PATH"' >> ~/.bashrc 
```

### ls
List directory
``` bash
# list everything in the directory (including hidden files)
ls -a
```

### man
Show the system's manual page.
``` bash
man chmod
```

### mkdir
Create a directory.
``` bash
mkdir new_dir
```

### rm
Remove file.
``` bash
rm -rf folder  # recursively forcibly remove a directory
```

### rmdir
Remove an empty directory.
```bash
rmdir folder
```

### touch
Create a file
``` bash
touch new_file.txt
```

# Basic Linux Commands

### >/dev/null
Avoid writing to the standard output.
```
command | tee file.out >/dev/null
```

### Run a bash script
``` bash
chmod +x script.sh
./script.sh
```

### Variable
Set variable and refer to it in subsequent commands.
```
my_name="Dave"
echo 'My name is $my_name'
```

# Basic Linux Concepts

## Package
A package is usually referred to an application but it could be a GUI application, command line tool or a software library (required by other software programs). A package is essentially an archive file containing the binary executable, configuration file and sometimes information about the dependencies.  

Debian: .deb  
Red Hat Linux: .rpm


## Package Manager
Package manager is a tool that allows users to install, remove, upgrade, configure and manage software packages on an operating system

RPM: Yum, DNF  
DEB: apt-get, aptitude

### Runtime Configuration (RC) file
The `rc` file is the main configuration file for the shell. The commands in this file are run every time a new shell is launched.
Example: ~/.bashrc file
After making changes to the rc file, to make the changes take effects, run
``` bash
source ~/.bashrc
```

### snap
If snap is not installed, on ubuntu/debian, run
``` bash
sudo apt install snapd
```

``` bash
# install vs code
sudo snap install --classic code
```

Remove snap app
``` bash
sudo snap remove code
```
## Personal Package Archive (PPA)
The PPA allows application developers and Linux users to create their own repositories to distribute software. It allows us to upload Ubuntu source packages to be built and published as an apt repository by Launchpad.

## Repository
The software in Linux is traditionally organized in repositories. Repositories contain applications and all the dependencies necessary to run them.


# Intermediate Linux Command

### grep
Search for patterns in file
``` bash
# find the files that match the pattern
grep -l "unix" *
```
``` bash
# find the patterns in the file (case insensitive)
grep -i "UNix" file.txt
```
``` bash
# use with pipe (select the outputs with certain pattern)
ls -l | grep "Aug"
```

### tee
Reads from the standard input and writes to both standard output and one or more files at the same time.
```
# print the disk usage and write to a file
df -h | tee disk_usage.txt
```


## Install Package from External Repositories
Sometimes, the application isn't in the default repositories, and we may need to install software from a 3rd party repository.  

Generally there are 3 steps involved:
- Adding the repository’s GPG key to the system
- Adding the external repository to the system
- Installing the package from this external repository

On Ubuntu and all Debian-based distros, the apt software repositories are defined in `/etc/apt/sources.list` file or in separate files under `/etc/apt/sources.list.d/` directory.

The general syntax of the /etc/apt/sources.list file takes the following format:
``` bash
deb http://repo.tld/ubuntu distro component
```
distro - beaver, xenial, ...
component - main, restricted, universe, multiverse
Example:
```
# mongodb
deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse
```

### Example 1: Spotify
1. Adding the repositories's GPG key to the system
``` bash
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
```
2. Adding the external repository to the system
``` bash
sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list'
```
3. Installing the package 
``` bash
sudo apt install spotify-client
```

### Example 2: VS Code
1. Adding the repositories's GPG key to the system
``` bash
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
```
2. Adding the external repository to the system
``` bash
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
```
Run this first if `add-apt-repository` doesn't exist
``` bash
sudo apt install software-properties-common apt-transport-https wget
```
3. Installing the package 
``` bash
sudo apt install code
```

### Example 3: ffmpeg
1. Adding the [PPA](#personal-package-archive-ppa) to the system
``` bash
sudo add-apt-repository ppa:jonathonf/ffmpeg-4
```
2. Installing the package 
``` bash
sudo apt install ffmpeg
```

There will be a `Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).`. You probably don't need to worry about it for now. For further information, check out [link](https://itsfoss.com/apt-key-deprecated/).

# Miscellaneous

### tree
Print the directory in a tree format.
``` bash
# Install the package tree
sudo apt install tree
```

``` bash
# print the root directory up to 2 levels
tree ~ -L 2
```

## Reference
https://linuxize.com/post/how-to-add-apt-repository-in-ubuntu/
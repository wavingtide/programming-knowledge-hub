# Most Basic Linux Commands

### apt update && apt upgrade
Update and upgrade packages
``` bash
sudo apt update && sudo apt upgrade -y
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

### echo
Repeat what you tell it to repeat
``` bash
echo This is a message
```
``` bash
# Output
This is a message
```

### ls
List directory
``` bash
ls -a
```

### mkdir
Create a directory.
``` bash
mkdir new_dir
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

## Repository
The software in Linux is traditionally organized in repositories. Repositories contain applications and all the dependencies necessary to run them.


# Intermediate Linux Command

### Grep


### tee
Reads from the standard input and writes to both standard output and one or more files at the same time.
```
# print the disk usage and write to a file
df -h | tee disk_usage.txt
```


### Set up an apt Repository

On ubuntu and all Debian-based distros, the apt software repositories are defined in `/etc/apt/sources.list` file or in separate files under `/etc/apt/sources.list.d/` directory.


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

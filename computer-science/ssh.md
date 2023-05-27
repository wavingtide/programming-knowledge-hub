# SSH
*(refer to [ssh.com](https://www.ssh.com/academy/ssh/protocol))*

The SSH protocol is a method for secure remote login from one computer to another. The protocol works in the client-worker model.

![](https://www.ssh.com/hubfs/Imported_Blog_Media/SSH_simplified_protocol_diagram-2.png)

The most common method for user authentication are passwords and public key authentication 

SSH introduced public key authentication, the idea is to have a cryptographic key pair - public key and private key, configure the public key on a server to authorize access and grant anyone who has a copy of the private key access to the server. The keys used for authentication are called **SSH keys**.

# Table of Contents
- [SSH](#ssh)
- [Table of Contents](#table-of-contents)
- [SSH Commands](#ssh-commands)
  - [Generate a new key](#generate-a-new-key)
  - [Copy the Public Key to the Server](#copy-the-public-key-to-the-server)
  - [Add the Key to SSH Agent](#add-the-key-to-ssh-agent)
    - [SSH Agent Forwarding](#ssh-agent-forwarding)
  - [Connect to a server](#connect-to-a-server)
- [Known Hosts](#known-hosts)


# SSH Commands
*(this session is based on OpenSSH)*
## Generate a new key
`ssh-keygen` is a tool for creating new authentication key pairs for SSH
``` shell
ssh-keygen -t ed25519
```
The command will prompt you to specify the file location and the passphrase.
![](https://i.imgur.com/bRVH2JX.png)

This will generate a public key and private key. By default, the keys are stored in `~/.ssh`.

A *passphrase* is used for encrypting the key, so that it cannot be used even if someone obtained the private key file.

Example of a private key
``` text
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDhOP9iG33GibfvgK3AKkFVUQXNoJY7RKBPmhcpFwmqAAAAAJiS/mXtkv5l
7QAAAAtzc2gtZWQyNTUxOQAAACDhOP9iG33GibfvgK3AKkFVUQXNoJY7RKBPmhcpFwmqAA
AAAEDJGpjPcN2dTvUQDavuS/e1vLXnhiXuTRkFVAtIYLxcYuE4/2IbfcaJt++ArcAqQVVR
Bc2gljtEoE+aFykXCaoAAAAAE3NvbWV0aGluZ0BnbWFpbC5jb20BAg==
-----END OPENSSH PRIVATE KEY-----
```

Example of a public key
``` text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE4/2IbfcaJt++ArcAqQVVRBc2gljtEoE+aFykXCaoA someone@LAPTOP-NJQNCV2N
```

SSH supports several public key algorithms for authentication keys. The algorithm can be specified using `-t` option and key size using `-b` option
``` shell
ssh-keygen -t rsa -b 4096
ssh-keygen -t dsa 
ssh-keygen -t ecdsa -b 521
ssh-keygen -t ed25519
```

## Copy the Public Key to the Server
To use public key authentication, the public key must be copied to a server. For example, GitHub allows the adding of SSH key to the GitHub account through GitHub CLI or Web browser.

OpenSSH has a command `ssh-copy-id` to install an SSH key on a server as an authorized key.
``` shell
ssh-copy-id -i ~/.ssh/mykey user@host
```

## Add the Key to SSH Agent
*(refer to [ssh-agent](https://www.ssh.com/academy/ssh/agent))*
The `ssh-agent` is a program that keep track of user's private key and their passphrases. On most Linux systems, `ssh-agent` is automatically configured and run at login. This implements a form of single sing-on (SSO).

Add SSH private key to the ssh-agent
``` shell
ssh-add <private_key_path>
```
Example
``` shell
ssh-add ~/.ssh/id_ed25519
```

### SSH Agent Forwarding
The SSH protocol implements *agent forwarding*, a mechanism whereby a SSH client allows an SSH server to use the local *ssh-agent* on the server as is it was local there.

To use agent forwarding, the `ForwardAgent` option must be set to yes on the client.

Example of `.ssh/config` file
``` text
Host github.com-repo-0
  ForwardAgent yes
  Hostname github.com
  IdentityFile=/home/user/.ssh/repo-0_deploy_key

Host github.com-repo-1
  ForwardAgent yes
  Hostname github.com
  IdentityFile=/home/user/.ssh/repo-1_deploy_key
```

## Connect to a server
``` shell
ssh user@host
```
Example
``` shell
ssh root@94.52.104.12
```

# Known Hosts
SSH clients store host keys for hosts they have ever connected to. The collection of known host keys is often called *known hosts*. In OpenSSH, the known host keys is stored in `/etc/ssh/known_hosts` and in `.ssh/known_hosts` in user's home directory.

To delete a single entry from known_hosts, run
``` shell
ssh-keygen -R <hostname>
```

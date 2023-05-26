# SSH
*(refer to [ssh.com](https://www.ssh.com/academy/ssh/protocol))*

The SSH protocol is a method for secure remote login from one computer to another. The protocol works in the client-worker model.

![](https://www.ssh.com/hubfs/Imported_Blog_Media/SSH_simplified_protocol_diagram-2.png)

The most common method for user authentication are passwords and public key authentication For public key authentication, the idea is to have a cryptographic key pair - public key and private key, configure the public key on a server to authorize access and grant anyone who has a copy of the private key access to the server. The keys used for authentication are called **SSH keys**.

# Table of Contents
- [SSH](#ssh)
- [Table of Contents](#table-of-contents)
- [SSH Commands](#ssh-commands)
  - [Generate a new key](#generate-a-new-key)
  - [Copy the Public Key to the Server](#copy-the-public-key-to-the-server)
  - [Add the Key to SSH Agent](#add-the-key-to-ssh-agent)
  - [Connect to a server](#connect-to-a-server)


# SSH Commands
## Generate a new key
``` shell
ssh-keygen -t ed25519 -C "something@gmail.com"
```
You can specify the file location and the passphrase.
![](https://i.imgur.com/bRVH2JX.png)

This will generate a public key and private key. By default, the keys are stored in `~/.ssh`.

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
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE4/2IbfcaJt++ArcAqQVVRBc2gljtEoE+aFykXCaoA something@gmail.com
```

SSH supports several public key algorithms for authentication keys. The algorithm is selected using `-t` option and key size using `-b` option
``` shell
ssh-keygen -t rsa -b 4096
ssh-keygen -t dsa 
ssh-keygen -t ecdsa -b 521
ssh-keygen -t ed25519
```

## Copy the Public Key to the Server
To use public key authentication, the public key must be copied to a server. Based on the server, you might use commands or manually copy the key.

``` shell
ssh-copy-id -i ~/.ssh/mykey user@host
```

## Add the Key to SSH Agent
`ssh-agent` is a program that can hold a user's private key.








## Connect to a server
``` shell
ssh user@host
```
Example
``` shell
ssh root@94.52.104.12
```

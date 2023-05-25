# SSH
*(refer to [ssh.com](https://www.ssh.com/academy/ssh/protocol))*

The SSH protocol is a method for secure remote login from one computer to another. The protocol works in the client-worker model.

![](https://www.ssh.com/hubfs/Imported_Blog_Media/SSH_simplified_protocol_diagram-2.png)

The most common method for user authentication are passwords and public key authentication For public key authentication, the idea is to have a cryptographic key pair - public key and private key, configure the public key on a server to authorize access and grant anyone who has a copy of the private key access to the server. The keys used for authentication are called **SSH keys**.

## SSH Commands
Generate a new key
``` shell
ssh-keygen -t ed25519 -C "email@gmail.com"
```
You can specify the file location and the passphrase.
![](https://i.imgur.com/bRVH2JX.png)

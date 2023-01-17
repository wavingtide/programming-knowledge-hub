# Dockerfile
Format of Dockerfile
``` text
# Comment
INSTRUCTION arguments
```

A `Dockerfile` must begin with a `FROM` instruction. The `FROM` instruction specifies the Parent Image from which you are building. 

A line starts with `#` is a comment.

# Table of Contents
- [Dockerfile](#dockerfile)
- [Table of Contents](#table-of-contents)
- [Things to Know](#things-to-know)
- [Parser directive](#parser-directive)
- [`.dockerignore` File](#dockerignore-file)
- [`FROM`](#from)
- [`WORKDIR`](#workdir)
- [`ENV`](#env)
- [`ARG`](#arg)
- [`RUN`](#run)
- [`CMD`](#cmd)
- [`ENTRYPOINT`](#entrypoint)
- [`LABEL`](#label)
- [`EXPOSE`](#expose)
- [`ADD` and `COPY`](#add-and-copy)
- [`VOLUME`](#volume)
- [`USER`](#user)
- [`SHELL`](#shell)
- [`ONBUILD`](#onbuild)
- [`STOPSIGNAL`](#stopsignal)
- [`HEALTHCHECK`](#healthcheck)


# Things to Know
- A pathname consisting of a single `/` shall resolve to the root directory of the process. A pathname without `/` is intepreted as a relative path.
- Filepath can contain wildcard, matching is done using Go’s [`filepath.Match`](https://pkg.go.dev/path/filepath#Match) rules. (Docker is written in Go)
- Some instructions that accepts commands as the argument  can accept commands in 2 forms, *shell form* and *exec form*
    - Command in *shell form* is run in a shell, which by default is `/bin/sh -c` on Linux or `cmd /S /C` on Windows.
        ``` text
        RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'
        ```
    - Command in *exec form* is passed as a JSON array (need to use double quotes(")). 
        ``` text
        RUN ["echo", "$HOME"]
        ```
        The *exec form* does not invoke a command shell. This means that normal shell processing does not happen. For example, `RUN ["echo", "$HOME"]` will not do variable substitution on `$HOME`. You can manually passing in the desired shell.
        ``` text
        RUN ["/bin/bash", "-c", "echo hello"]
        ```
        > It is necessary to escape backslashes in JSON form, it is especially relevant on Windows (eg: `RUN ["c:\\windows\\system32\\tasklist.exe"]`)

# Parser directive
A Parser directive tell Docker daemon how to read the Dockerfile and is optional. If it is included, it should appear before `FROM` and follow by a blank line.

This can be useful for Windows, as Windows path name usually contain backslash, `\`. Backslash is the default escape character of Dockerfile.
``` text
# escape=` (backtick)

FROM python-3.8
```

# `.dockerignore` File
Docker CLI will exclude files and directories that match patterns in it, before sending them to the docker daemon. This helps to avoid unnecessarily sending large or sensitive files and directories to the daemon.

For the purposes of matching, the root of the context is considered to be both the working and the root directory.

Example:
``` text
# comment
*/temp*
*/*/temp*
temp?
*.md
!README.md
```

# `FROM`
The `FROM` instruction initializes a new build stage and sets the Base Image for subsequent instructions.
``` text
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
```
``` text
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
```

You can search for existing docker image from [Docker Hub](https://hub.docker.com/search?image_filter=official&q=).
``` text
FROM ubuntu:bionic
```
``` text
FROM python:3.9-slim
```

`FROM` can appear multiple times within a single `Dockerfile` to create multiple images or perform multi-stage builds. Optionally, a name can be given to a new build stage with `AS name`. `tag` and `digest` are optional and default to `latest`.

Example:
``` text
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps
```

# `WORKDIR`
The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the Dockerfile. It is default as root directory (`/`).

``` text
WORKDIR /path/to/workdir
```

It is best practice to set the `WORKDIR` explicitly.

# `ENV`
Environment variable can be declared using `ENV` statement.
``` text
ENV <key>=<value> ...
```

``` text
ENV greet=hello
ENV greet=hi word=$greet
# word will be assign "hello" instead of "hi"
ENV vocab=$greet

ENV MY_NAME="John Doe"
ENV MY_DOG=Rex\ The\ Dog
```

Environment variables are notated as `$variable_name` or `${variable_name}` in `Dockerfile`.

The `${variable_name}` also supported a few standard bash modifiers.
``` text
# if variable exists, then variable, else word
${variable:-word}

# if variable exists, then word, else empty
${variable:+word}
```

Adding `\` to escape a environment variable.
``` text
\$foo
```
You can change the environment variables when using `docker run`.
``` shell
docker run --env <key>=<value>
```

If an environment variable is only needed during build, consider setting a value for a single command.
``` text
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...
```
Or use `ARG`
``` text
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ...
```

# `ARG`
`ARG` instructions can be used to define a variable in a Dockefile that exists during built time. It can be passed into a Dockerfile with `docker build --build-arg <varname>=<value>`. 
``` text
ARG <name>[=<default value>]
```

It can be used before `FROM`.
``` text
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```

An ARG instruction goes out of scope at the end of the build stage where it was defined. To use an argument in multiple stages, each stage must include the ARG instruction.

``` text
ARG VERSION=latest
FROM busybox:$VERSION
ARG VERSION
RUN echo $VERSION > image_version
```

``` text
FROM busybox
ARG SETTINGS
RUN ./run/setup $SETTINGS

FROM busybox
ARG SETTINGS
RUN ./run/other $SETTINGS
```

`ARG` will be preceded by `ENV` if the variables have the same names.

# `RUN`
The `RUN` instruction will execute any commands in a new layer.
`RUN` has 2 forms
- `RUN <command>` (*shell form*)
- `RUN ["executable", "param1", "param2"]` (*exec form*)

``` text
RUN ["/bin/bash", "-c", "echo hello"]
```

# `CMD`
The `CMD` instruction has three forms:
- `CMD ["executable","param1","param2"]` (*exec form*, preferred)
- `CMD ["param1","param2"]` (as *default parameters to ENTRYPOINT*)
- `CMD command param1 param2` (shell form)

There can only be one `CMD` instruction in a Dockerfile. If you list more than one `CMD` then only the last `CMD` will take effect.

The main purpose of a `CMD` is to provide defaults for an executing container. If you specify arguments to `docker run`, they will override the default specified in CMD.

You can provide the executable (such as `/bin/sh -c`) when constructing `CMD`. Else, you can set the executable using `ENTRYPOINT`.

Example:
``` text
FROM ubuntu
CMD echo "This is a test." | wc -
```

``` text
FROM ubuntu
CMD ["/usr/bin/wc","--help"]
```

# `ENTRYPOINT`
An `ENTRYPOINT` allows you to configure a container that will run as an executable (eg: nginx, shell).

`ENTRYPOINT` has two forms:
- `ENTRYPOINT ["executable", "param1", "param2"]` (*exec form*, preferred)
- `ENTRYPOINT command param1 param2` (*shell form*)

Only the last `ENTRYPOINT` instruction in the `Dockerfile` will take effect.

When `ENTRYPOINT` is specified and you run `docker run <image> <command>`, the command will be run as `<ENTRYPOINT> <command>`. You can override the `ENTRYPOINT` instruction using the `docker run --entrypoint` flag.

It is not advisable to use *shell form*, as your `ENTRYPOINT` will be started as a subcommand of `/bin/sh -c`. *Shell form* will also ignore any `CMD` and `docker run` command line argument.

You can use the *exec form *of `ENTRYPOINT` to set fairly stable default commands and arguments and then use either form of `CMD` to set additional defaults that are more likely to be changed.

Example:
``` text
FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]
```

``` text
FROM ubuntu
ENTRYPOINT exec top -b
```

# `LABEL`
The `LABEL` instruction adds metadata to an image.

``` text
LABEL <key>=<value> <key>=<value> <key>=<value> ...
```

``` text
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```

You can also set multiple lables in a single instructions.
``` text
LABEL multi.label1="value1" multi.label2="value2" other="value3"
```

To view an image's labels, use the `docker image inspect` command. Use `--format` option to show just the labels.
``` shell
docker image inspect --format='' myimage
```
``` shell
{
  "com.example.vendor": "ACME Incorporated",
  "com.example.label-with-value": "foo",
  "version": "1.0",
  "description": "This text illustrates that label-values can span multiple lines.",
  "multi.label1": "value1",
  "multi.label2": "value2",
  "other": "value3"
}
```

# `EXPOSE`
The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime. You can specify TCP (default) or UDP.

``` text
EXPOSE <port> [<port>/<protocol>...]
```

The `EXPOSE` instruction does not actually publish the port. To actually publish the port, use `-p` flag on `docker run`.

``` text
EXPOSE 80/udp
EXPOSE 80/udp
```

``` shell
docker run -p 80:80/tcp -p 80:80/udp ...
```

# `ADD` and `COPY`
The `ADD` instruction copies new files, directories **or remote file URLs** from `<src>` and adds them to the filesystem of the image at the path `<dest>`.

The `COPY` instruction copies new files or directories from `<src>` and adds them to the filesystem of the container at the path `<dest>`.

`ADD` and `COPY` are almost the same, the major diffence is that `ADD` allows `<src>` to be a URL. 

They accept the following format
``` text
ADD [--chown=<user>:<group>] [--checksum=<checksum>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
```
``` text
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

Example:
``` text
ADD hom* /mydir/
COPY hom?.txt /mydir/
ADD ["Folder 1/File.txt", "Dir 1/"]

# add a file of name arr[0].txt
COPY arr[[]0].txt /mydir/
```
The `--chown` feature is only supported on Dockerfiles used to build Linux containers. Both UID and GID are default as 0. The format of the `--chown` flag allows for either *username and groupname strings* or *direct integer UID and GID* in any combination. Providing a *username without groupname* or a *UID without GID* will use the same numeric UID as the GID.

``` text
ADD --chown=55:mygroup files* /somedir/
COPY --chown=bin files* /somedir/
ADD --chown=1 files* /somedir/
COPY --chown=10:11 files* /somedir/
```

In the case where `<src>` is a remote file URL, the destination will have permissions of 600.

Optionally, `COPY` accepts a flag `--from=<name>` that can be used to set the source location to a previous build stage. This can be helpful when performing multi-stage build.

# `VOLUME`
The `VOLUME` instruction creates a mount point with the specified name and marks it as holding externally mounted volumes from native host or other containers.
``` text
VOLUME ["/data"]
```

# `USER`
The `USER` instruction sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for the remainder of the current stage.
``` text
USER <user>[:<group>]
```
``` text
USER <UID>[:<GID>]
```

On Windows, the user must be created first if it's not a built-in account.
``` shell
FROM microsoft/windowsservercore
# Create Windows user in the container
RUN net user /add patrick
# Set it for subsequent commands
USER patrick
```

# `SHELL`
The `SHELL` instruction allows the default shell used for the shell form of commands to be overridden. The default shell on Linux is `["/bin/sh", "-c"]`, and on Windows is `["cmd", "/S", "/C"]`.
``` text
SHELL ["executable", "parameters"]
```

Example:
``` text
# Executed as powershell -command Write-Host hello
SHELL ["powershell", "-command"]
RUN Write-Host hello

# Executed as cmd /S /C echo hello
SHELL ["cmd", "/S", "/C"]
RUN echo hello
```

# `ONBUILD`
The `ONBUILD` instruction adds to the image a trigger instruction to be executed at a later time, when the image is used as the base for another build. The trigger will be executed in the context of the downstream build, as if it had been inserted immediately after the `FROM` instruction in the downstream `Dockerfile`.

``` text
ONBUILD <INSTRUCTION>
```

Example:
``` text
ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
```

# `STOPSIGNAL`
The STOPSIGNAL instruction sets the system call signal that will be sent to the container to exit.
``` text
STOPSIGNAL signal
```

# `HEALTHCHECK`
The `HEALTHCHECK` instruction tells Docker how to test a container to check that it is still working.
``` text
# check container health by running a command inside the container
HEALTHCHECK [OPTIONS] CMD command
```
``` text
# disable any healthcheck inherited from the base image
HEALTHCHECK NONE
```

Only the last `HEALTHCHECK` instruction in Dockerfile will take effect.

The options that can appear before CMD are:
- `--interval=DURATION` (default: 30s)
- `--timeout=DURATION` (default: 30s)
- `--start-period=DURATION` (default: 0s)
- `--retries=N` (default: 3)

Example
``` text
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

The command’s exit status indicates the health status of the container. The possible values are:
- 0: success - the container is healthy and ready for use
- 1: unhealthy - the container is not working correctly
- 2: reserved - do not use this exit code

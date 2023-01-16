# Dockerfile

# Format of Dockerfile
``` text
# Comment
INSTRUCTION arguments
```

A `Dockerfile` must begin with a `FROM` instruction. The `FROM` instruction specifies the Parent Image from which you are building. 

A line starts with `#` is a comment.

# Parser directive
A Parser directive tell Docker daemon how to read the Dockerfile and is optional. If it is included, it should appear before `FROM` and follow by a blank line.

This can be useful for Windows, as Windows path name usually contain backslash, `\`, Backslash is the default escape character of Dockerfile.
``` text
# escape=` (backtick)

FROM python-3.8
```

# Environment Variable
Environment variable can be declared using `ENV` statement.
``` text
ENV greet=hello
ENV greet=hi word=$greet
ENV vocab=$greet
```

Environment variables are notated as `$variable_name` or `${variable_name}` in `Dockerfile`.

The `${variable_name}` also supported a few standard bash modifiers.
``` text
# if variable exist, then variable, else word
${variable:-word}

# if variable existm then word, else empty
${variable:+word}
```

Adding `\` to escape a environment variable.
``` text
\$foo
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

Example:
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

# `ARG`
`ARG` instructions can be used to define a temporary variable in a Dockefile. It can be used before `FROM`.
``` text
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```

An ARG declared before a `FROM` is outside of a build stage, so it can’t be used in any instruction after a `FROM`. To use it, do
``` text
ARG VERSION=latest
FROM busybox:$VERSION
ARG VERSION
RUN echo $VERSION > image_version
```

# `RUN`
The `RUN` instruction will execute any commands in a new layer.
`RUN` has 2 forms
- `RUN <command>` (*shell form*)
- `RUN ["executable", "param1", "param2"]` (*exec form*)

## Shell Form
The command is run in a shell, which by default is `/bin/sh -c` on Linux or `cmd /S /C` on Windows.

You can continue a line using `\`.
``` shell
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
```

## Exec Form
The *exec form* is passed as a JSON array (need to use double quotes(")). 
> It is necessary to escape backslashes in JSON form, it is especially relevant on Windows (eg: `RUN ["c:\\windows\\system32\\tasklist.exe"]`)

The *exec form* does not invoke a command shell. This means that normal shell processing does not happen. For example, `RUN ["echo", "$HOME"]` will not do variable substitution on `$HOME`. You can manually passing in the desired shell, `RUN ["/bin/bash", "-c", "echo hello"]`.

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
`ENTRYPOINT` has two forms:
- `ENTRYPOINT ["executable", "param1", "param2"]` (*exec form*)
- `ENTRYPOINT command param1 param2` (*shell form*)



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
The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime. Can specify TCP (default) or UDP.

The EXPOSE instruction does not actually publish the port. To actually publish the port, use `-p` flag on `docker run`.

``` text
EXPOSE 80/udp
EXPOSE 80/udp
```

``` shell
docker run -p 80:80/tcp -p 80:80/udp ...
```

# `ADD`
The `ADD` instruction copies new files, directories or remote file URLs from `<src>` and adds them to the filesystem of the image at the path `<dest>`.

# `COPY`
The `COPY` instruction copies new files or directories from `<src>` and adds them to the filesystem of the container at the path `<dest>`.

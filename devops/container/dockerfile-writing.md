# Dockerfile

# Format of Dockerfile
``` shell
# Comment
INSTRUCTION arguments
```

A `Dockerfile` must begin with a `FROM` instruction. The `FROM` instruction specifies the Parent Image from which you are building. 

A line starts with `#` is a comment.

# Parser directive
A Parser directive tell Docker daemon how to read the Dockerfile and is optional. If it is included, it should appear before `FROM` and follow by a blank line.

This can be useful for Windows, as Windows path name usually contain backslash, `\`, Backslash is the default escape character of Dockerfile.
``` shell
# escape=` (backtick)

FROM python-3.8
```

# Environment Variable
Environment variable can be declared using `ENV` statement
``` shell
ENV greet=hello
ENV greet=hi word=$greet
ENV vocab=$greet
```

Environment variables are notated as `$variable_name` or `${variable_name}` in `Dockerfile`.

The `${variable_name}` also supported a few standard bash modifiers.
``` shell
# if variable exist, then variable, else word
${variable:-word}

# if variable existm then word, else empty
${variable:+word}
```

Adding `\` to escape a environment variable.
``` shell
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


# Run


# CMD


# Label


# Expose


# Add


# Copy


# Entrypoint


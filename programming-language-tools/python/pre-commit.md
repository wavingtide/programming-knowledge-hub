# Pre-commit
Pre-commit is one of the Git hooks. Git hooks are scripts to run when a particular event happens. Pre-commit literally runs before a commit takes place.

It is usually used to make sure that the code is linted and formatted properly.

# Installation
Using pip
``` shell
pip install pre-commit
```

Using brew
``` shell
brew install pre-commit
```

Using conda
``` shell
conda install -c conda-forge pre-commit
```

# `.pre-commit-config.yaml`
Example:
``` shell
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
    -   id: black
```

# Install the Git Hook Scripts
``` shell
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

Now `pre-commit` will run automatically on `git commit`
